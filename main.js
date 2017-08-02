var position_option = {
    "Goalkeeper": 0.8,
    "Defender": 0.9,
    "Defensive midfielder": 1,
    "Attacking midfielder": 1.1,
    "Forward": 1.2
},
    experience_option = {
    "domestic league": 0.9,
    "UEFA Europa League": 1,
    "UEFA Champions League": 1.1
},
    contract_option = {
    "0.5 year": 0.5,
    "1 year": 0.9,
    "1.5 years": 1,
    "> 2 years": 1.1,
    "> 3 years": 1.2,
    "> 4 years": 1.3
},
    age_option = {
    "less than 18": 0.8,
    "18 - 29": 1,
    "more than 29": 0.8
}

var age = document.querySelector('#age'),
    experience = document.querySelector('#experience'),
    contract = document.querySelector('#contract'),
    position = document.querySelector('#position'),
    currency = document.querySelector('#currency'),
    academy = document.querySelector('#academy'),
    purchase = document.querySelector('#purchase-value'),
    salary = document.querySelector('#salary'),
    calculateButton = document.querySelector('#calculate'),
    selectAgeOption = 1,
    selectExperienceOption = 1,
    selectContractOption = 1,
    selectPositionOption = 1,
    selectAcademyOption = 1;

(function insertAge() {
    for (var age_key in age_option) {
        var ageContent = document.createElement('option');
        ageContent.innerHTML =  age_key;
        ageContent.dataset.index = age_option[age_key];
        age.appendChild(ageContent);
    } 
})();

(function insertExperience() {
    for (var experience_key in experience_option) {
        var experienceContent = document.createElement('option');
        experienceContent.innerHTML = experience_key;
        experienceContent.dataset.index = experience_option[experience_key];
        experience.appendChild(experienceContent);
    }
})();

(function insertContract() {
    for (var contract_key in contract_option) {
        var contractContent = document.createElement('option');
        contractContent.innerHTML = contract_key;
        contractContent.dataset.index = contract_option[contract_key];
        contract.appendChild(contractContent);
    }
})();

(function insertPosition() {
    for (var position_key in position_option) {
        var positionContent = document.createElement('option');
        positionContent.innerHTML = position_key;
        positionContent.dataset.index = position_option[position_key];
        position.appendChild(positionContent);
    }
})();

age.onchange = function() {
    selectAgeOption = document.querySelector('#age option:checked').dataset.index;
}

experience.onchange = function() {
    selectExperienceOption = document.querySelector('#experience option:checked').dataset.index;
}

contract.onchange = function() {
    selectContractOption = document.querySelector('#contract option:checked').dataset.index;
}

position.onchange = function() {
    selectPositionOption = document.querySelector('#position option:checked').dataset.index;
}

currency.onchange = function selectCurrency() {
    var checkedCurrency = document.querySelector('#currency label > input:checked'),
        parentCurrencyNode = checkedCurrency.parentNode,
        currencyValue = document.querySelector('#currencyValue'),
        selectCurrencyOption = parentCurrencyNode.children[2].innerHTML;
    currencyValue.innerText = selectCurrencyOption;
}

academy.onchange = function selectAcademy() {
    var checkedAcademy = document.querySelector('#academy label > input:checked'),
        parentAcademyNode = checkedAcademy.parentNode,
        youthAcademy = parentAcademyNode.children[2].innerText;

    if(youthAcademy == 'Yes') {
        purchase.setAttribute('disabled', 'disabled');
        purchase.value = 0;
        selectAcademyOption = document.querySelector('#academy label > input:checked').dataset.index;
    } else {
        purchase.removeAttribute('disabled');
        purchase.value = '';
        selectAcademyOption = document.querySelector('#academy label > input:checked').dataset.index;
    };
}