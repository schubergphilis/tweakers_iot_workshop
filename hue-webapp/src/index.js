const hue = require('node-hue-api').v3;
const express = require('express');
const convert = require('color-convert');
const convertoXy = require('@q42philips/hue-color-converter')

const PORT = process.env.PORT_NUMBER || 3000;
const REFRESH_INTERVAL = process.env.REFRESH_INTERVAL || 300000;
const CLIENT_ID = process.env.CLIENT_ID;
const CLIENT_SECRET = process.env.CLIENT_SECRET;
const APP_ID = process.env.APP_ID;
const STATE = process.env.STATE;

let accessToken = process.env.ACCESS_TOKEN || null
let refreshToken = process.env.REFRESH_TOKEN || null
let userName = process.env.USER_NAME || null

const LightState = hue.lightStates.LightState;
const GroupLightState = hue.lightStates.GroupLightState

const app = express();
const remote = hue.api.createRemote(CLIENT_ID, CLIENT_SECRET);

let hueApi = null;

app.set('query parser', 'simple')

// Redirect to ask the user access to his bridges through this "app"
app.get('/authenticate', (req, res) => {
  let state = req.query.state
  if (STATE != state) {
    res.status(401).send('Unauthorized');
  }
  else {
    res.redirect(remote.getAuthCodeUrl('node-hue-api-remote', APP_ID, STATE));
  }
});
// On call back authenticate and start a loop to keep the tokens fresh
app.get('/callback', (req, res) => {
  remote.connectWithCode(req.query.code)
    .then((api) => {
      hueApi = api;
      refreshWithTokens()
      console.log('Ready to receive events');
      res.status(200).send('Ready to receive events');
    })
    .catch((error) => {
      console.log(error.message);
      res.status(500).send('Internal server error');
    });
});

app.get('/setlight', (req, res) => {
  const query = new URLSearchParams(req.query)
  if (query.has('name') && query.has('colour')) {

    const lightName = req.query.name
    const lightColour = req.query.colour

    let lightObject = null

    connectwithTokens()
      .then(() => {
        return hueApi.lights.getLightByName(lightName.toLowerCase())
      })
      .then(light => {
        lightObject = light
        let colour_rgb = convert.keyword.rgb(lightColour.toLowerCase())

        const lightState = new LightState()
          .on()
          .xy(convertoXy.calculateXY.apply(null, colour_rgb))
          .brightness(30)
          ;
        return hueApi.lights.setLightState(light.id, lightState);
      })
      .catch(() => {
        console.log(`No light found with name ${lightName}`)
        throw `No light found with name ${lightName}`
      })
      .then(() => {
        return hueApi.lights.getLightState(lightObject.id)
      })
      .then(lightstate => {
        let lightresult = {
          name: lightObject._data.name,
          productname: lightObject._data.productname,
          manufacturername: lightObject._data.manufacturername,
          state: lightstate
        }
        res.header("Content-Type", 'application/json');
        res.status(200).send(JSON.stringify(lightresult, null, 2));
      })
      .catch((error) => {
        res.status(500).send(error);
      })
  } else {
    res.status(400).send('No name and colour provided!')
  }
});

app.get('/setGroup', (req, res) => {
  const query = new URLSearchParams(req.query)
  if (query.has('group') && query.has('colour')) {

    const lightGroup = req.query.group
    const lightColour = req.query.colour

    let lightGroupObject = null

    connectwithTokens()
      .then(() => {
        return hueApi.groups.getGroupByName(lightGroup)
      })
      .then(group => {

        lightGroupObject = group[0]
        let colour_rgb = convert.keyword.rgb(lightColour)

        const groupLightState = new GroupLightState()
          .on()
          .xy(convertoXy.calculateXY.apply(null, colour_rgb))
          .brightness(30)
          ;
        return hueApi.groups.setGroupState(lightGroupObject.id, groupLightState);
      })
      .catch(() => {
        console.log(`No group found with name ${lightGroup}`)
        throw `No group found with name ${lightGroup}`
      })
      .then(() => {
        return hueApi.groups.getGroupState(lightGroupObject.id)
      })
      .then(groupState => {
        let groupResult = {
          name: lightGroupObject.name,
          lights: lightGroupObject.lights,
          type: lightGroupObject.type,
          state: groupState
        }
        res.header("Content-Type", 'application/json');
        res.status(200).send(JSON.stringify(groupResult, null, 2));
      })
      .catch((error) => {
        res.status(500).send(error);
      })
  } else {
    res.status(400).send('No group and colour provided!')
  }
});

app.get('/getlights', (req, res) => {
  connectwithTokens()
    .then(() => {
      return hueApi.lights.getAll();
    })
    .then(allLights => {

      let result = []

      allLights.forEach(light => {
        let lightresult = {
          name: light.name,
          productname: light.productname,
          manufacturername: light.manufacturername,
          state: {
            on: light.state.on,
            brightness: light.state.bri,
            hue: light.state.hue,
            saturation: light.state.sat
          }
        }
        result.push(lightresult)
      });

      function compare(a, b) {
        const nameA = a.name.toUpperCase();
        const nameB = b.name.toUpperCase();

        let comparison = 0;
        if (nameA > nameB) {
          comparison = 1;
        } else if (nameA < nameB) {
          comparison = -1;
        }
        return comparison;
      }

      res.setHeader('Content-Type', 'application/json');
      res.status(200).send(JSON.stringify(result.sort(compare), null, 2));
    })
    .catch((error) => {
      res.setHeader('Content-Type', 'application/json');
      res.status(500).send(error);
    })
});

app.get('/', (req, res) => {

  connectwithTokens()
    .then(() => {
      return hueApi.configuration.getConfiguration();
    })
    .then(config => {
      let result = {
        name: config._data.name,
        zigbeechannel: config._data.zigbeechannel,
        version: {
          api: config._data.apiversion,
          software: config._data.swversion
        }
      }
      res.setHeader('Content-Type', 'application/json');
      res.status(200).send(JSON.stringify(result, null, 2));
    })
    .catch((error) => {
      res.status(500)
      res.send(error);
    })
});

app.listen(PORT, () => { console.log('App started listening on port: ', PORT); });

function connectwithTokens() {
  return remote.connectWithTokens(accessToken, refreshToken, userName)
    .then((api) => {
      hueApi = api;
      console.debug('connected with tokens');
    })
    .catch((error) => {
      console.error(`Failed to connect with tokens ${error}`);
      throw "Failed to connect with tokens"
    });
}

function refreshWithTokens() {
  if (!accessToken) {
    const remoteCredentials = hueApi.remote.getRemoteAccessCredentials();
    accessToken = remoteCredentials.tokens.access.value;
    refreshToken = remoteCredentials.tokens.refresh.value;
    userName = remoteCredentials.username;

    console.log(`username: ${userName} `);
    console.log(`access token: ${accessToken}`);
    console.log(`refresh Token: ${refreshToken} \n`);
    console.log('\nNote: You should securely store the tokens and username from above as you can use them to connect\n')
  }
  try {
    connectwithTokens();
    console.debug("Refreshed tokens")
    setTimeout(refreshWithTokens, REFRESH_INTERVAL);
  }
  catch {
    setTimeout(refreshWithTokens, 5000);
  }
}
