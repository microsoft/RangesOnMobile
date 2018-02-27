var path = require('path');
var webpack = require('webpack');
var jshint = require('jshint-loader');

module.exports = {
  entry: './src/index.js',

  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'public'),
    publicPath: '/'
  },

  module: {
    rules: [
        {
          test: /\.js$/, // include .js files
          enforce: "pre", // preload the jshint loader
          exclude: /node_modules/, // exclude any and all files in the node_modules folder
          use: [
            {
                loader: "jshint-loader"
            }
          ]
        }
    ]    
  },
  // externals: {
  //     'socket.io': "socket.io"
  // },
  
  devServer: {
    hot: true, // Tell the dev-server we're using HMR
    contentBase: path.resolve(__dirname, 'public'),
    publicPath: '/'
  },

  devtool: "inline-source-map"
  
};