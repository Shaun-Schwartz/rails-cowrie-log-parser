/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import React from 'react';
import ReactDOM from 'react-dom'
import {Navigation} from '../components/Navigation'

document.addEventListener('DOMContentLoaded', () => {
  const navigationDiv = document.querySelector('#Navigation');
  ReactDOM.render(
    <Navigation />,
    navigationDiv
  )

  // Show / hide charts on index page based on user selection
  const hour = $('.hour')
  const day = $('.24-hours')
  const week = $('.week')
  $('.hour-button').click(function() {
    if (hour.attr('class').includes('hidden')) {
      hour.removeClass('hidden');
      Chartkick.eachChart( function(chart) {
        chart.redraw();
      });
    }
    if (!day.attr('class').includes('hidden')) {
      day.addClass('hidden')
    }
    if (!week.attr('class').includes('hidden')) {
      week.addClass('hidden')
    }
  })

  $('.24-hours-button').click(function() {
    if (!hour.attr('class').includes('hidden')) {
      hour.addClass('hidden')
    }
    if (day.attr('class').includes('hidden')) {
      day.removeClass('hidden');
      Chartkick.eachChart( function(chart) {
        chart.redraw();
      });
    }
    if (!week.attr('class').includes('hidden')) {
      week.addClass('hidden')
    }
  })

  $('.week-button').click(function() {
    if (!hour.attr('class').includes('hidden')) {
      hour.addClass('hidden')
    }
    if (!day.attr('class').includes('hidden')) {
      day.addClass('hidden')
    }
    if (week.attr('class').includes('hidden')) {
      week.removeClass('hidden');
      Chartkick.eachChart( function(chart) {
        chart.redraw();
      });
    }
  })
})
