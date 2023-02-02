// in src/authProvider.js
import {  Account } from 'appwrite'; 
import {appwriteClient} from './constant'


const account = new Account(appwriteClient);
const authProvider = {
    // called when the user attempts to log in
    login: ({ email,password }) => {
        console.log(email, password);
        let promise = account.createEmailSession(email, password);
        
        promise.then(function (response) {
            console.log(response);
            localStorage.setItem('email', email);
            localStorage.setItem('a_session', response.$id);
        }, function (error) {
            
            console.log(error); // Failure
        });


        // accept all username/password combinations
        return Promise.resolve();
    },
    // called when the user clicks on the logout button
    logout: () => {
        let promise = account.deleteSession(localStorage.getItem('a_session'));
        
        promise.then(function (response) {
            console.log(response);
        }, function (error) {
            
            console.log(error); // Failure
        });

        localStorage.removeItem('email');
        localStorage.removeItem('a_session');
        return Promise.resolve();
    },
    // called when the API returns an error
    checkError: ({ status }) => {
        if (status === 401 || status === 403) {
            localStorage.removeItem('username');
            return Promise.reject();
        }
        return Promise.resolve();
    },
    // called when the user navigates to a new location, to check for authentication
    checkAuth: () => {
        return localStorage.getItem('username')
            ? Promise.resolve()
            : Promise.reject();
    },
    // called when the user navigates to a new location, to check for permissions / roles
    getPermissions: () => Promise.resolve(),
};

export default authProvider;
