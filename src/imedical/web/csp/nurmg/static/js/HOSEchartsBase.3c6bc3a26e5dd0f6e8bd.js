webpackJsonp([320],{k5OC:function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var n=a("Dd8w"),i=a.n(n),r=a("NYxO"),o=(a("7t+N"),a("Icdr")),s={name:"EchartsComm",computed:i()({},Object(r.b)(["Height","Width"])),props:{Option:{type:Object,default:{}},EleId:{type:String,default:"echartscomm"},OpenDialog:{type:Boolean,default:!1},OpenParam:{type:String,default:""},OpenDialogName:{type:String,default:"护理管理"}},data:function(){return{DefaultOption:{tooltip:{trigger:"item",axisPointer:{type:"shadow"}},grid:{left:"3%",right:"4%",top:"8%",bottom:"3%",containLabel:!0},toolbox:{show:!0,left:"right",feature:{dataView:{show:!0},restore:{show:!0},magicType:{show:!0,type:["line","bar"]},saveAsImage:{show:!0}}},legend:{left:"center",top:"bottom"}},MyChart:""}},methods:{DrawCharts:function(){var t=this;this.$nextTick(function(){t.MyChart=o.init(document.getElementById(t.EleId)),t.MyChart.clear(),t.$nextTick(function(){t.MyChart.resize(),t.MyChart.setOption(t.Option),t.OpenDialog&&t.MyChart.on("click",function(e){var a="";try{a=SESSIONHL4_1.MWToken}catch(t){}var n={name:t.OpenDialogName,link:"https://114.251.235.22:1443/imedical/web/csp/dhc.nursemg.four.main.csp?Router=HOSTable&MWToken="+a+"&"+t.OpenParam+"&SeriesName="+e.seriesName+"&InnerType="+e.name};window.parent.parent.postMessage({embedWindow:n},"*")})})})}},created:function(){this.DrawCharts()},beforeDestroy:function(){this.MyChart.dispose()}},c={render:function(){var t=this.$createElement,e=this._self._c||t;return"echartscomm"==this.EleId?e("div",{staticStyle:{width:"100%",height:"100%"}},[e("div",{staticStyle:{margin:"0px auto",width:"100%",height:"100%"},attrs:{id:"echartscomm"}})]):this._e()},staticRenderFns:[]},h=a("VU/8")(s,c,!1,null,null,null);e.default=h.exports}});