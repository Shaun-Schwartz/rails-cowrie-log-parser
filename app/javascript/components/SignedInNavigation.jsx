import React, {Component} from 'react';
import {
  Collapse,
  Navbar,
  NavbarToggler,
  NavbarBrand,
  Nav,
  NavItem,
  NavLink
} from 'reactstrap';

class SignedInNavigation extends Component {
  constructor (props) {
    super (props);
  }

  render() {
    return (
      <Navbar color="dark" dark expand="sm">
        <NavbarBrand href="/"></NavbarBrand>
        <Collapse navbar>
          <Nav className="react-navbar ml-auto" navbar>
            <NavItem>
              <NavLink href="/">Home</NavLink>
            </NavItem>
            <NavItem>
              <NavLink href="/all">All</NavLink>
            </NavItem>
            <NavItem>
              <NavLink href="/hour">Hour</NavLink>
            </NavItem>
            <NavItem>
              <NavLink href="/day">Day</NavLink>
            </NavItem>
            <NavItem>
              <NavLink href="/week">Week</NavLink>
            </NavItem>
            <NavItem key='1'>
              <NavLink data-method="DELETE" href="/session">Sign Out</NavLink>
            </NavItem>
          </Nav>
        </Collapse>
      </Navbar>
    )
  }
}

export {SignedInNavigation};
