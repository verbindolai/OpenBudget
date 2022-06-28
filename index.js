import "react-native-get-random-values";
import React, { useEffect } from "react";
import { AppRegistry, Button, View } from "react-native";
import { name as appName } from "./app.json";
import { Text } from "react-native";
import Realm from "realm";
import { NavigationContainer } from "@react-navigation/native";
import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { Header } from "react-native/Libraries/NewAppScreen";

const Stack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();

function HomeScreen({route, navigation}) {
  return (
    <View style={{ flex: 1, alignItems: "center", justifyContent: "center" }}>
      <Text>Home Screen</Text>
      <Button title={'Details'} onPress={() => {
        navigation.navigate("Details")
      }}/>
    </View>
  );
}

function DetailsScreen() {
  return (
    <View style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}>
      <Text>Details Screen</Text>

    </View>
  );
}

function HomeStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="HomeStack" component={HomeScreen} />
      <Stack.Screen name="Details" component={DetailsScreen} />
    </Stack.Navigator>
  );
}

function SettingsScreen() {
  return (
    <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
      <Text>Settings!</Text>
    </View>
  );
}


const App = () => {
  return (
    <NavigationContainer>
      <Tab.Navigator >
        <Tab.Screen name="Home" component={HomeStack} options={{headerShown: false}}/>
        <Tab.Screen name="Settings" component={SettingsScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
};
AppRegistry.registerComponent(appName, () => App);
