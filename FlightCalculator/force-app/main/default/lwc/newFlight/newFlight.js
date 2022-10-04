import { LightningElement, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import calculateAndSaveFlight from '@salesforce/apex/NewFlightService.calculateAndSaveFlight';
import fetchAirports from '@salesforce/apex/NewFlightService.fetchAirports';
import { labels } from 'c/labelUtils';

export default class NewFlight extends LightningElement {
    @track createdFlight;
    label = labels;

    airportOptions = [];
    airportAllData = [];

    airportDepartureValue;
    airportArrivalValue;

    @wire(fetchAirports)
    wiredAirports({error, data}) {
        if (data) {
            this.airportAllData = [...data];
            let airportData = [];
            data.forEach(ev => {
                airportData.push({label: ev.IATA__c, value: ev.Id});
            });
            this.airportOptions = [...airportData];
        } else if (!data) {
            this.showToast(this.label.missingData, 'warning');
        } else if (error) {
            this.showToast(this.label.unexpectedErrorLabel, 'error');
        }
    }

    handleChange(event) {
        if (event.target.name == "departureAirport") {
            this.airportDepartureValue = event.target.value;
        } else if (event.target.name == "arrivalAirport") {
            this.airportArrivalValue = event.target.value;
        }
    }

    handleFlightCreation() {
        if (this.airportDepartureValue && this.airportArrivalValue && this.airportDepartureValue === this.airportArrivalValue) {
            this.showToast(this.label.makeSureBeforeSave, 'error');
        } else if (this.validateInputs()) {
            calculateAndSaveFlight({airports: this.fetchAirportData()})
                .then((result) => {
                    this.createdFlight = result;
                }).catch((error) => {
                    this.showToast(error.body.message, 'error');
                });
        }
    }
    
    validateInputs() {
        let isValid = true;
        this.template.querySelectorAll('lightning-combobox').forEach((field) => {
            if (!field.reportValidity()) {
                isValid = field.reportValidity();
            } 
        });
        return isValid;
    }

    fetchAirportData() {
        let arr = [];
        arr.push(this.airportAllData.find(el => el.Id == this.airportDepartureValue));
        arr.push(this.airportAllData.find(el => el.Id == this.airportArrivalValue));
        return arr;
    }

    get showResult() {
        if (this.createdFlight) {
            return true;
        }
        return false;
    }

    get flightName() {
        return this.createdFlight.name;
    }

    get departureAirport() {
        return this.createdFlight.departureName;
    }

    get arrivalAirport() {
        return this.createdFlight.arrivalName;
    }

    get flightDistance() {
        return this.createdFlight.distance;
    }

    showToast(msg, vrt) {
        this.dispatchEvent(new ShowToastEvent({
            message: msg,
            variant: vrt,
        }));
    }
}