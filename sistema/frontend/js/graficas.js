//graficas
var myChart1;
var myChart2;
var myChart3;
var myChart4;
var myChart5;

//colores
const colors = [
    'rgba(204, 153, 204)',  // Rosado pálido
    'rgba(187, 143, 206)',  // Morado pálido
    'rgba(200, 160, 221)',  // Lila pálido
    'rgba(191, 191, 191)',  // Gris pálido
    'rgba(168, 168, 168)',  // Gris neutro
    'rgba(189, 170, 199)',  // Lila grisáceo
    'rgba(193, 184, 200)',  // Lila suave
    'rgba(234, 176, 228)',  // Rosa magenta
    'rgba(216, 191, 216)',  // Orquídea pálido
    'rgba(187, 143, 206)',  // Morado pálido

  ];


//TOP DE PRODUCTOS MÁS VENDIDOS
fetch('http://localhost:3000/products')
  .then(response => response.json())
  .then(data => {

    products = []
    products_sales = []

    for (let product of data){
        products.push(product['ProductName'])
        products_sales.push(product['TotalSales'])


        if (myChart1 != null) {
            myChart1.destroy();
        }

        let ctx1 = document.getElementById('status-chart').getContext('2d');
        myChart1 = new Chart(ctx1, {
            type: "bar",
            data: {
                labels: products,
                datasets: [{
                    label: "Ventas en promociones",
                    data: products_sales,
                    backgroundColor: colors
                }
                ]
            },
            options: {
                responsive: true
            }
        });
    }
  })
.catch(error => console.error('Error:', error));

//VENTAS POR AÑO
fetch('http://localhost:3000/year_sales')
  .then(response => response.json())
  .then(data => {

    date = []
    total_sales = []

    for (let product of data){
        date.push(product['Date'])
        total_sales .push(product['AccumulatedSales'])


         //Pie chart
         if (myChart2 != null) {
            myChart2.destroy();
        }
        let ctx2 = document.getElementById('line-chart').getContext('2d');
        myChart2 = new Chart(ctx2, {
            type: "line",
            data: {
                labels: date,
                datasets: [{
                    label: "Ventas en promociones",
                    backgroundColor: colors,
                    data: total_sales
                }]
            },
            options: {
                responsive: true,

            }
        });
    }
  })
.catch(error => console.error('Error:', error));

//VENTAS POR DESCUENTOS
fetch('http://localhost:3000/discount_pct')
  .then(response => response.json())
  .then(data => {

    discount = []
    total_sales = []

    for (let product of data){
        discount .push(product['DiscountPct'])
        total_sales .push(product['TotalSales'])


         //Pie chart
         if (myChart3 != null) {
            myChart3.destroy();
        }
        let ctx3 = document.getElementById('pie-chart').getContext('2d');
        myChart3 = new Chart(ctx3, {
            type: "pie",
            data: {
                labels: discount,
                datasets: [{
                    backgroundColor: colors,
                    data: total_sales
                }]
            },
            options: {
                responsive: true
            }
        });
    }
  })
.catch(error => console.error('Error:', error));


//VENTAS POR TERRITORIO
fetch('http://localhost:3000/territory')
  .then(response => response.json())
  .then(data => {

    countries = []
    territory_sales = []

    for (let product of data){
        countries.push(product[ "TerritoryCountry"])
        territory_sales.push(product['TotalSales'])


        if (myChart4 != null) {
            myChart4.destroy();
        }

         // Types Doughnut
         var ctx4 = document.getElementById("types-chart").getContext("2d");
         myChart4 = new Chart(ctx4, {
             type: "doughnut",
             data: {
                 labels: countries,
                 datasets: [{
                     backgroundColor: colors,
                     data: territory_sales
                 }]
             },
             options: {
                 responsive: true
             }
         });
    }
  })
.catch(error => console.error('Error:', error));


//CLIENTES FIELES
fetch('http://localhost:3000/customer')
  .then(response => response.json())
  .then(data => {

    names = []
    totalPP = []

    for (let product of data){
        names.push(product[ "CustomerName"])
        totalPP.push(product["TotalPromotionPurchases"])


        if (myChart5 != null) {
            myChart5.destroy();
        }

         // Types Doughnut
         var ctx5 = document.getElementById("bar-chart").getContext("2d");
         myChart5 = new Chart(ctx5, {
             type: "bar",
             data: {
                 labels: names,
                 datasets: [{
                    label: "Ventas en promociones",
                     backgroundColor: colors,
                     data: totalPP
                 }]
             },
             options: {
                 responsive: true,
                 indexAxis: 'y',  // Establecer el eje de índice en vertical
                scales: {
                    x: {
                        beginAtZero: true  // Asegurar que el eje x comience en 0
                    }
                }
             }

         });
    }
  })
.catch(error => console.error('Error:', error));

(function ($) {
    "use strict";

    // Spinner
    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 1);
    };
    spinner();


    // Back to top button

    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            $('.back-to-top').fadeIn('slow');
        } else {
            $('.back-to-top').fadeOut('slow');
        }
    });
    $('.back-to-top').click(function () {
        $('html, body').animate({ scrollTop: 0 }, 1500, 'easeInOutExpo');
        return false;
    });


    // Sidebar Toggler
    $('.sidebar-toggler').click(function () {
        $('.sidebar, .content').toggleClass("open");
        return false;
    });


    // Progress Bar
    $('.pg-bar').waypoint(function () {
        $('.progress .progress-bar').each(function () {
            $(this).css("width", $(this).attr("aria-valuenow") + '%');
        });
    }, { offset: '80%' });


    // Testimonials carousel
    $(".testimonial-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1000,
        items: 1,
        dots: true,
        loop: true,
        nav: false
    });


})(jQuery);

