window.addEventListener("load", () => {
    const priceInput = document.getElementById("item-price");
    priceInput.addEventListener("input", () => {
        const inputValue = priceInput.value;
        const addTaxDom = document.getElementById("add-tax-price");
        const Tax = Math.floor(inputValue * 0.1);
        addTaxDom.innerHTML = Tax.toLocaleString();
        const addProfitDom = document.getElementById("profit");
        addProfitDom.innerHTML = (inputValue - Tax).toLocaleString();
    });
});