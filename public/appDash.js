
 axios({
  method: 'post',
  url: '/admin/getdata',
  data: {
  id:8
  }
}).then(res=>{
  let Revenue=Array.from(res.data).map(a => a.total/1000)
  let mon=Array.from(res.data).map(a => a.mon)
  let No_orders=Array.from(res.data).map(a=>a.orders_cnt);
  let Net_Profit=[0,0,0,0]
  for (let i = 0; i < Revenue.length; i++) {
    Net_Profit[i]=Revenue[i]*.2
  }
console.log(res.data)
var options = {
    series: [{
    name: 'Net Profit',
    data:Net_Profit
  }, {
    name: 'Revenue',
    data:Revenue
  }, {
    name: 'No_orders',
    data: No_orders
  }],
    chart: {
    type: 'bar',
    height: 350
  },
  plotOptions: {
    bar: {
      horizontal: false,
      columnWidth: '50px',
      endingShape: 'rounded', borderRadius: 4,
     
    },
  },
  dataLabels: {
    enabled: false
  },
  stroke: {
    show: true,
    width: 2,
    colors: ['transparent']
  },  colors: ['#010101', '#e1e7e9', '#c5caff'],
  xaxis: {
    categories: mon,
  },
  yaxis: [
    {
      labels: {
        formatter: function(val) {
          return val.toFixed(0);
        }
      }
      ,title:{
        text:"(K) EGP"
      }
    }
  ],
  fill: {
    opacity: 1
  },
  tooltip: {
    y: {
      formatter: function (val) {
        return  val + "(K) EGP"
      }
    }
  },title: {
    text: "Orders Summery",
    align: 'left',
    margin: 10,
    offsetX: 5,
    offsetY: 5,
    floating: false,
    style: {
      fontSize:  '18px',
      fontWeight:  'bold',
      fontFamily:  "Segoe UI",
      color:  '#263238'
    },
}
  };

  var chart = new ApexCharts(document.querySelectorAll("#chart")[1], options);
  chart.render();
});
function setdatetotal(d) {
  let x = new Date(d);
  return `${x.getDate()} ${x.toLocaleString('en-US', { month: 'short' })} `;
}
axios({
  method: 'post',
  url: '/getstat',
  data: {
  id:8
  }
}).then(res=>{
  let visits=Array.from(res.data).map(a => a.no_visits)
  let timeOnPage=Array.from(res.data).map(a => a.seconds/60)
  let date=Array.from(res.data).map(a=>setdatetotal(a.vist_date));
  var options1 = {
    series: [{
      name: "Session Duration",
      data: timeOnPage
    },
    {
      name: 'Total Visits',
      data: visits
    }
  ],
    chart: {
    height: 350,
    type: 'line',
    zoom: {
      enabled: false
    },
  },
  dataLabels: {
    enabled: false
  },
  stroke: {
    width: 2,
    curve: 'straight',
  },
  title: {
    text: "Site Statistics",
  align: 'left',
  margin: 10,
  offsetX: 5,
  offsetY: 5,
  floating: false,
  style: {
    fontSize:  '18px',
    fontWeight:  'bold',
    fontFamily:  "Segoe UI",
    color:  '#263238'
  },
  },
  legend: {

    tooltipHoverFormatter: function(val, opts) {
      return val + ' - ' + opts.w.globals.series[opts.seriesIndex][opts.dataPointIndex] + ''
    }
  },
  markers: {
    size: 0,
    hover: {
      sizeOffset: 6
    }
  },
  xaxis: {
    categories: date,
  },
  yaxis: [
    {
      labels: {
        formatter: function(val) {
          return val.toFixed(0);
        }
      }
     
    }
  ],
  tooltip: {
    y: [
      {
        labels: {
          formatter: function(val) {
            return val.toFixed(0);
          }
        }
        ,
        title: {
          formatter: function (val) {
            return val + " (mins)"
          }
        }
      },{
        title: {
          formatter: function (val) {
            return val;
          }
        }
      }
    ]
  },
  grid: {
    borderColor: '#f1f1f1',
  }
  };

  var chartx = new ApexCharts(document.querySelectorAll("#chart")[0], options1);
  chartx.render();

})