webpackJsonp([312],{"0ZIV":function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var r=a("Icdr");a("GbHy"),a("Oq2I"),a("miEh");var n={name:"NurInfoStatisticBar",props:["data"],watch:{data:function(t,e){this.loadData()}},methods:{loadData:function(){this.drawCharts()},drawCharts:function(){var t=this;t.$nextTick(function(){r.dispose(document.getElementById("quesChartBar"));var e=r.init(document.getElementById("quesChartBar")),a={toolbox:{show:!0,x:"center",feature:{dataView:{show:!0},restore:{show:!0},saveAsImage:{show:!0}}},tooltip:{trigger:"item",formatter:function(t){return t.name}},grid:{left:"3%",right:"4%",bottom:"3%",containLabel:!0},legend:{data:t.data.map(function(t,e,a){return t.name}),formatter:function(t){return t.length>10?t.substr(0,10)+"...":t},orient:"vertical",textStyle:{color:"black"},x:"70%",y:"center"},xAxis:[{type:"category",data:t.data.map(function(t,e,a){return t.name})}],yAxis:[{type:"value",minInterval:1,min:0,max:50,axisLabel:{formatter:"{value}"}}],series:[{type:"bar",data:t.data.map(function(t,e,a){return t.value}),barGap:"-100%",barMaxWidth:50,itemStyle:{normal:{label:{show:!0,position:"top",textStyle:{color:"black",fontSize:16}}}}}]};e.setOption(a)})}},created:function(){this.loadData()}},i={render:function(){this.$createElement;this._self._c;return this._m(0)},staticRenderFns:[function(){var t=this.$createElement,e=this._self._c||t;return e("div",{staticClass:"echart-mouse",staticStyle:{width:"100%",height:"100%"}},[e("div",{staticStyle:{margin:"20px auto",width:"100%",height:"500px"},attrs:{id:"quesChartBar"}})])}]},o=a("VU/8")(n,i,!1,null,null,null);e.default=o.exports}});