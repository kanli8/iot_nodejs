import * as React from "react";
import { Admin, Resource } from 'react-admin';


import { AppwriteDataProvider, AppwriteAuthProvider } from "ra-appwrite";

import { UserList } from './users';
import jsonServerProvider from 'ra-data-json-server';
import authProvider from './authProvider';

import MyLoginPage from './MyLoginPage';


const dataProvider = jsonServerProvider('https://jsonplaceholder.typicode.com');


const App = () => (
   <Admin loginPage={MyLoginPage} dataProvider={dataProvider} authProvider={authProvider} >
       <Resource name="users" list={UserList} />
   </Admin>
);


export default App;
