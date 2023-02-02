import * as React from 'react';
import { useState } from 'react';
import { useLogin, useNotify, Notification } from 'react-admin';
import './css/login.css';
const MyLoginPage = ({ theme }) => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const login = useLogin();
    const notify = useNotify();

    const handleSubmit = e => {
      
        e.preventDefault();
        login({ email, password }).catch(() =>
            notify('Invalid email or password')
        );
    };

    return (

        <form onSubmit={handleSubmit} className="box">
            <h1>Login</h1>
            <br />
            <hr />
            <input 
                type="text" 
                name="email" 
                placeholder="Email" 
                onChange={e => setEmail(e.target.value)} 
                />
            <input 
                type="password" 
                name="password" 
                placeholder="Password" 
                onChange={e => setPassword(e.target.value)}
                />
            <input 
                type="submit" 
                name="" value="Login" />
            {/* <p>Forget password ?</p> */}
        </form>
        
        // <form onSubmit={handleSubmit}>
        //         <input
        //             name="email"
        //             type="email"
        //             value={email}
        //             onChange={e => setEmail(e.target.value)} />
        //         <input
        //             name="password"
        //             type="password"
        //             value={password}
        //             onChange={e => setPassword(e.target.value)} />
        //     </form>
    );
};

export default MyLoginPage;