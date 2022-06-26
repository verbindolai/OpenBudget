/**
 * @format
 */

import 'react-native-get-random-values';
import React, {useEffect} from 'react';
import {AppRegistry} from 'react-native';
import {name as appName} from './app.json';
import {SafeAreaView, Text} from 'react-native';
import Realm from 'realm';

const TaskSchema = {
  name: 'Task',
  properties: {
    _id: 'int',
    name: 'string',
    status: 'string?',
  },
  primaryKey: '_id',
};

const App = () => {
  Realm.open({
    path: 'myrealm',
    schema: [TaskSchema],
  }).then(realm => {
    const tasks = realm.objects('Task');
    console.log(tasks);
  });

  return (
    <SafeAreaView>
      <Text>Hallo</Text>
    </SafeAreaView>
  );
};
AppRegistry.registerComponent(appName, () => App);
