import {LightningElement, track, wire} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import calculateAndSaveFlight from '@salesforce/apex/NewFlightService.calculateAndSaveFlight';
import fetchAirports from '@salesforce/apex/NewFlightService.fetchAirports';
import getAllAirports from '@salesforce/apex/NewFlightService.getAllAirports';
import {labels} from 'c/labelUtils';

const columns = [{label: 'IATA', fieldName: 'IATA__c'}];

export default class NewFlight extends LightningElement {
    @track createdFlight;
    label = labels;

    airportOptions = [];
    airportAllData = [];

    airportDepartureValue;
    airportArrivalValue;
    searchValue;
    displayDepartureResult;
    displayArrivalResult;
    displayResult;
    columns = columns;

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

    handleKeyChange(event){
        this.searchValue = event.target.value;
        this.imperativeCall(event.target.name);
    }

    imperativeCall(name){
        getAllAirports({searchKey : this.searchValue})
        .then((result) => {
            if(name == "departureAirport"){
                this.displayDepartureResult = result;
            } else if(name == "arrivalAirport"){
                this.displayArrivalResult = result;
            }
        })
        .catch((error) => {
            console.log('Error occured in Search JS: ', error);
        });
    }

    handleRowSelection(event){
        const selectionRow = event.detail.selectedRows;
        if (event.target.name == "departureAirport") {
            this.airportDepartureValue = selectionRow;
        } else if (event.target.name == "arrivalAirport") {
            this.airportArrivalValue = selectionRow;
        }
    }

    handleFlightCreation() {
        if (this.airportDepartureValue === undefined || this.airportArrivalValue === undefined) {
            this.showToast(this.label.somethingIsMissing, 'error');
        } else if(this.airportDepartureValue[0].Id === this.airportArrivalValue[0].Id){
            this.showToast(this.label.airportsCannotBeTheSame, 'error');
        } else if(this.airportDepartureValue[1] || this.airportArrivalValue[1] ){
            this.showToast(this.label.chooseOnlyOneAirport, 'error');
        } else if (this.validateInputs()) {
            calculateAndSaveFlight({airports: this.fetchAirportData()})
            .then((result) => {
                this.createdFlight = result;
                this.refresh();
            }).catch((error) => {
                this.showToast(error.body.message, 'error');
            });
        }
    }
    
    refresh() {
        this.airportDepartureValue = undefined;
        this.airportArrivalValue = undefined;
        this.displayDepartureResult = undefined;
        this.displayArrivalResult = undefined;
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
        arr.push(this.airportAllData.find(el => el.Id == this.airportDepartureValue[0].Id));
        arr.push(this.airportAllData.find(el => el.Id == this.airportArrivalValue[0].Id));
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