import arrivalAirport from '@salesforce/label/c.ArrivalAirport';
import departureAirport from '@salesforce/label/c.DepartureAirport';
import flightDistance from '@salesforce/label/c.FlightDistance';
import createdFlight from '@salesforce/label/c.CreatedFlight';
import unexpectedError from '@salesforce/label/c.UnexpectedError';
import airportsCannotBeTheSame from '@salesforce/label/c.AirportsCannotBeTheSame';
import somethingIsMissing from '@salesforce/label/c.SomethingIsMissing';
import chooseOnlyOneAirport from '@salesforce/label/c.ChooseOnlyOneAirport';

const labels = {
    arrivalAirport,
    departureAirport,
    flightDistance,
    createdFlight,
    unexpectedError,
    airportsCannotBeTheSame,
    somethingIsMissing,
    chooseOnlyOneAirport
}

export {labels};