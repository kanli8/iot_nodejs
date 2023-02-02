var createError = require('http-errors');
var express = require('express');
var session = require('express-session')
var bodyParser = require('body-parser')
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');


var useRoute = require('./routes/useRoute');

var app = express();
const sessionParser = session({
    saveUninitialized: false,
    secret: "$eCuRiTy",
    resave: false,
    // cookie: { secure: false } //https 才可以设为true,http 需要设置为false
});


app.use(sessionParser);
app.use(bodyParser.json({ type: 'application/*+json' }))
// parse an HTML body into a string
app.use(bodyParser.text({ type: 'text/html' }))

//use session
app.set('trust proxy', 1) // trust first proxy


// view engine setup
app.engine('html', require('ejs').renderFile);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'html');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/user', useRoute);




// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});




app.sessionParser = sessionParser

module.exports = app;
