import logo from './logo.svg';

import { styled } from '@mui/material/styles';
import Button from '@mui/material/Button';
import Grid from '@mui/material/Grid';
import Paper from '@mui/material/Paper';
import Divider from '@mui/material/Divider';
import TextField from '@mui/material/TextField';


import { 
  LineChart, 
  Line, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  Legend, 
  ResponsiveContainer,
  ReferenceLine } from 'recharts';


import './App.css';


const data = [
  {
    "name": 1,
    "uv": 4000,
    "pv": 2400,
    "amt": 2400
  },
  {
    "name": 2,
    "uv": 3000,
    "pv": 1398,
    "amt": 2210
  },
  {
    "name": 3,
    "uv": 2000,
    "pv": 9800,
    "amt": 2290
  },
  {
    "name": 4,
    "uv": 2780,
    "pv": 3908,
    "amt": 2000
  },
  {
    "name": 5,
    "uv": 1890,
    "pv": 4800,
    "amt": 2181
  },
  {
    "name": 6,
    "uv": 2390,
    "pv": 3800,
    "amt": 2500
  },
  {
    "name": 7,
    "uv": 3490,
    "pv": 4300,
    "amt": 2100
  },
  {
    "name": 8,
    "uv": 4000,
    "pv": 2400,
    "amt": 2400
  },
  {
    "name": 9,
    "uv": 3000,
    "pv": 1398,
    "amt": 2210
  },
  {
    "name": 10,
    "uv": 2000,
    "pv": 9800,
    "amt": 2290
  },
  {
    "name": 11,
    "uv": 2780,
    "pv": 3908,
    "amt": 2000
  },
  {
    "name": 12,
    "uv": 1890,
    "pv": 4800,
    "amt": 2181
  },
  {
    "name": 13,
    "uv": 2390,
    "pv": 3800,
    "amt": 2500
  },
  {
    "name": 14,
    "uv": 3490,
    "pv": 4300,
    "amt": 2100
  },
  {
    "name": 1,
    "uv": 4000,
    "pv": 2400,
    "amt": 2400
  },
  {
    "name": 2,
    "uv": 3000,
    "pv": 1398,
    "amt": 2210
  },
  {
    "name": 3,
    "uv": 2000,
    "pv": 9800,
    "amt": 2290
  },
  {
    "name": 4,
    "uv": 2780,
    "pv": 3908,
    "amt": 2000
  },
  {
    "name": 5,
    "uv": 1890,
    "pv": 4800,
    "amt": 2181
  },
  {
    "name": 6,
    "uv": 2390,
    "pv": 3800,
    "amt": 2500
  },
  {
    "name": 7,
    "uv": 3490,
    "pv": 4300,
    "amt": 2100
  },
  {
    "name": 8,
    "uv": 4000,
    "pv": 2400,
    "amt": 2400
  },
  {
    "name": 9,
    "uv": 3000,
    "pv": 1398,
    "amt": 2210
  },
  {
    "name": 10,
    "uv": 2000,
    "pv": 9800,
    "amt": 2290
  },
  {
    "name": 11,
    "uv": 2780,
    "pv": 3908,
    "amt": 2000
  },
  {
    "name": 12,
    "uv": 1890,
    "pv": 4800,
    "amt": 2181
  },
  {
    "name": 13,
    "uv": 2390,
    "pv": 3800,
    "amt": 2500
  },
  {
    "name": 14,
    "uv": 3490,
    "pv": 4300,
    "amt": 2100
  }
] ;


function App() {
  return (
    <div className="App">
      <Grid container spacing={2}>
      <Grid item xs={5}>
        <Grid container spacing={2}>
          <Grid item xs={12}>
            基础功能区:
          </Grid>
          <Grid item xs={2}>
          <Button variant="contained">配网</Button>
          </Grid>
          <Grid item xs={3}>
            <Button variant="contained">重启ESP</Button>

          </Grid>
          <Grid item xs={4}>
            <Button variant="contained">获取ESPwifi状态</Button>
          </Grid>
          <Grid item xs={4}>
            <Button variant="contained">获取服务器连接信息</Button>
          </Grid>
          

          <Grid item xs={12}>
            设备功能区:
          </Grid>

          <Grid item xs={4}>
            <Button variant="contained">*米饭</Button>
          </Grid>
          <Grid item xs={4}>
            <Button variant="contained">炖煮</Button>
          </Grid>
          <Grid item xs={4}>
            <Button variant="contained">粥</Button>
          </Grid>


          <Grid item xs={12}>预设温控曲线</Grid>
          <Grid item xs={12} height="200px">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart
              width={500}
              height={300}
              data={data}
              margin={{
                top: 5,
                right: 30,
                left: 20,
                bottom: 5,
              }}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Line type="monotone" dataKey="pv" stroke="#8884d8" activeDot={{ r: 8 }} />
              <Line type="monotone" dataKey="uv" stroke="#82ca9d" />
              <Line type="monotone" dataKey="amt" stroke="#82ca9d" />
              <ReferenceLine x="5" stroke="green" label="cur" />

            </LineChart>
          </ResponsiveContainer>

          </Grid>


          
        </Grid>
      </Grid>{/**左侧区 end */}
      <Divider orientation="vertical" variant="middle" flexItem />

      <Grid item xs={6}>
        <Grid item xs={12}>
            日志记录（1000行）:
          </Grid>
          <Grid item xs={12}>
            <TextField
              width="200px"
              id="outlined-multiline-static"
              fullWidth 
              multiline
              rows={20}
              defaultValue="Default Value"
            />
          </Grid>
      </Grid>{/**左侧区 end */}

        
  
      </Grid>
      
    </div>
  );
}

export default App;
