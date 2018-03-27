import React from 'react';
import ReactDOM from 'react-dom'
import {Navigation} from '../components/Navigation'
import {SignedInNavigation} from '../components/SignedInNavigation'

document.addEventListener('DOMContentLoaded', () => {
  const navigationDiv = document.querySelector('#Navigation');
  ReactDOM.render(<Navigation />,navigationDiv)

  const signedInDiv = document.querySelector('#SignedIn');
  ReactDOM.render(<SignedInNavigation />,signedInDiv)

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
