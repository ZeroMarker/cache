(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-67634daa"],{1761:function(e,t,r){"use strict";var s=r("8715"),a=r.n(s);a.a},2877:function(e,t,r){"use strict";function s(e,t,r,s,a,o,n,i){var c,d="function"===typeof e?e.options:e;if(t&&(d.render=t,d.staticRenderFns=r,d._compiled=!0),s&&(d.functional=!0),o&&(d._scopeId="data-v-"+o),n?(c=function(e){e=e||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext,e||"undefined"===typeof __VUE_SSR_CONTEXT__||(e=__VUE_SSR_CONTEXT__),a&&a.call(this,e),e&&e._registeredComponents&&e._registeredComponents.add(n)},d._ssrRegister=c):a&&(c=i?function(){a.call(this,this.$root.$options.shadowRoot)}:a),c)if(d.functional){d._injectStyles=c;var l=d.render;d.render=function(e,t){return c.call(t),l(e,t)}}else{var h=d.beforeCreate;d.beforeCreate=h?[].concat(h,c):[c]}return{exports:e,options:d}}r.d(t,"a",(function(){return s}))},"28bc":function(e,t,r){},"3af4":function(e,t,r){"use strict";var s=r("bbe1"),a=r.n(s);a.a},"43b2":function(e,t,r){"use strict";var s=r("d4de"),a=r.n(s);a.a},"53c9":function(e,t,r){"use strict";var s=r("9d4a"),a=r.n(s);a.a},"6e1b":function(e,t,r){"use strict";var s=r("28bc"),a=r.n(s);a.a},7903:function(e,t,r){"use strict";t["a"]={getSheetsOfSSGroup:{className:"Nur.NIS.Service.OrderExcute.SheetConfig",methodName:"GetCurrentSheets",type:"post"},getSheetButtons:{className:"Nur.NIS.Service.OrderExcute.QueryOrder",methodName:"GetSheetButtons",type:"post"},getSheetColumns:{className:"Nur.NIS.Service.OrderExcute.QueryOrder",methodName:"GetSheetColumns",type:"post"},getExecConfig:{className:"Nur.NIS.Service.OrderExcute.QueryOrder",methodName:"GetQueryConfig",type:"post"},getOrders:{className:"Nur.NIS.Service.OrderExcute.QueryOrder",methodName:"GetOrders",type:"post"},getDisposeStateInfo:{className:"Nur.NIS.Service.OrderExcute.QueryOrder",methodName:"GetDisposeStateInfo",type:"post"},getAttachOrder:{className:"Nur.NIS.Service.Base.Order",methodName:"GetAttachOrder",type:"post"},getLibPhaRule:{className:"Nur.NIS.Service.Base.Order",methodName:"GetLibPhaRule",type:"post"},getCloseLoopInfo:{className:"Nur.PDA.InterFace",methodName:"getOrdCloseLoopInfo",type:"post"},getSameLabNoMessage:{className:"Nur.NIS.Service.OrderExcute.Print",methodName:"GetSameLabNoMessage",type:"post"},getCollectAttention:{className:"Nur.NIS.Service.Base.Order",methodName:"GetCollectAttention",type:"post"},getPrintFlagDesc:{className:"Nur.NIS.Service.OrderExcute.QueryOrder",methodName:"GetPrintFlagDesc",type:"post"},setPlacerNo:{className:"Nur.NIS.Service.Base.OrderHandle",methodName:"setPlacerNo",type:"post"},updateSpacer:{className:"Nur.NIS.Service.Base.OrderHandle",methodName:"updateSpacer",type:"post"},seeOrderChunks:{className:"Nur.NIS.Service.Base.OrderHandle",methodName:"SeeOrderChunks",type:"post"},execAttachAricm:{className:"Nur.NIS.Service.Base.OrderHandle",methodName:"execAttachAricm",type:"post"},gePrintOrderInfo:{className:"Nur.NIS.Service.OrderExcute.SheetNew",methodName:"GetPrintOrderInfo",type:"post"},getHospital:{className:"Nur.NIS.Service.OrderExcute.SheetNew",methodName:"GetHospital",type:"post"},getQueryTitle:{className:"Nur.NIS.Service.OrderExcute.SheetNew",methodName:"GetQueryTitle",type:"post"},getSheetName:{className:"Nur.NIS.Service.OrderExcute.SheetNew",methodName:"GetSheetName",type:"post"},setExecPrintFlag:{className:"Nur.NIS.Service.Base.OrderHandle",methodName:"setExecPrintFlag",type:"post"},getSheetComineFilter:{className:"Nur.NIS.Service.OrderExcute.SheetConfig",methodName:"GetSheetComineFilter",type:"post"},saveOrdCheckOrd:{className:"Nur.NIS.Service.AttachOrder.Biz",methodName:"SaveOrdCheckOrd",type:"post"},getFormWork:{className:"Nur.NIS.Service.OrderExcute.XMLPrint",methodName:"GetFormwork",type:"post"},getPrintData:{className:"Nur.NIS.Service.OrderExcute.XMLPrint",methodName:"GetPrintData",type:"post"},getLisBarOrdStr:{className:"Nur.NIS.Service.OrderExcute.Print",methodName:"GetLisBarOrdStr",type:"post"},getLisBar:{className:"Nur.NIS.Service.OrderExcute.Print",methodName:"LisBar",type:"post"},getCardPrintSetting:{className:"Nur.NIS.Service.OrderExcute.CardPrint",methodName:"GetBasicPrintSetting",type:"post"},getCardPrintForm:{className:"Nur.NIS.Service.OrderExcute.CardPrint",methodName:"GetPrintForm",type:"post"},getCardPrintData:{className:"Nur.NIS.Service.OrderExcute.CardPrint",methodName:"GetAllPrintData",type:"post"},getSheetPrintSetting:{className:"Nur.NIS.Service.OrderExcute.SheetPrint",methodName:"GetBasicPrintSetting",type:"post"},getSheetPrintForm:{className:"Nur.NIS.Service.OrderExcute.SheetPrint",methodName:"GetPrintForm",type:"post"},getSheetPrintData:{className:"Nur.NIS.Service.OrderExcute.SheetPrint",methodName:"GetAllPrintData",type:"post"},seeOrdersAndGetPrint:{className:"Nur.NIS.Service.Base.OrderHandle",methodName:"SeeOrdersAndGetPrint",type:"post"},setOrderPrintFlag:{className:"Nur.NIS.Service.Base.OrderHandle",methodName:"setOrderPrintFlag",type:"post"},getExecAttArcim:{className:"Nur.NIS.Service.OrderExcute.QueryOrder",methodName:"GetAttArcim",type:"post"},getPrtConfig:{className:"Nur.NIS.Service.OrderExcute.NurPrintBusiness",methodName:"GetPrtConfig",type:"post"}}},8715:function(e,t,r){},"88fa":function(e,t,r){"use strict";r.r(t);var s=function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("td",{staticClass:"orderArcimDesc",style:e.getOrdBackgroundColor(),on:{click:function(t){return t.stopPropagation(),e.toggleTimeChartShow.apply(null,arguments)}}},[e.order.emergency?r("span",{staticClass:"orderArcimDesc_sealSpanWrapper"},[r("span",{staticClass:"orderArcimDesc_sealSpan is-emergency"},[e._v(e._s(e.$t("急")))])]):e._e(),void 0!==e.order.abnorm?r("span",{staticClass:"orderArcimDesc_sealSpanWrapper"},[r("span",{class:["orderArcimDesc_sealSpan",e.skinTestColor]},[e._v("\n      "+e._s(e.$t(e.getSkinTestText(e.order)))+"\n    ")])]):e._e(),r("a-tooltip",{attrs:{placement:"top",visible:!!e.order.libPhaRuleDesc&&e.visible},on:{visibleChange:e.handleVisibleChange}},[r("div",{staticClass:"orderArcimDesc_libPhaRuleDesc",attrs:{slot:"title"},domProps:{innerHTML:e._s(e.order.libPhaRuleDesc)},slot:"title"},[e._v("\n      "+e._s(e.order.libPhaRuleDesc)+"\n    ")]),r("span",{staticClass:"orderArcimDesc_mainOrder",style:e.getMainOrderArcimDescStyle(),on:{mouseover:function(t){return t.stopPropagation(),e.$listeners.onOrderArcimDescHover(e.order)}}},[e._v("\n      "+e._s(e.order[e.code])+"\n      "),e._l(e.order.ordAddInfoValueList,(function(t,s){return["ALL"===t.itemShowMode||e.orderShowMode&&"OrdExec"===t.itemShowMode||!e.orderShowMode&&"Ord"===t.itemShowMode?["printFlag"===t.key?[e._l(e.printFlags,(function(t,s){return[r("span",{key:"printFlag"+s,staticClass:"orderArcimDesc_printFlag"},[e._v("\n                "+e._s(t)+"\n              ")])]}))]:["containerInfo"!==t.key?r("span",{key:"addInfoItem"+s,style:{backgroundColor:t.backgroundColor,color:t.fontColor,"font-size":"ordPriorNotes"===t.key?"10px":"14px"}},[e._v(e._s(e.$t(e.getAddInfoValue(e.order,t)))+"\n            ")]):r("span",{key:"addInfoItem"+s},[t.value&&t.value.desc?[r("a-tooltip",{attrs:{placement:"bottom",title:t.value.desc+"\n"+(e.order.collectAttention?e.order.collectAttention:"")}},[""!==t.value.notes?r("span",{staticClass:"orderArcimDesc_orderContainerInfo",style:{backgroundColor:""+("#00ffff"===t.value.color?"#1890ff":t.value.color),border:"#ffffff"===t.color?"1px solid #000":"",color:"#ffff00"===t.value.color||"#ffffff"===t.value.color?"#000":"#fff"},on:{mouseover:function(t){return t.stopPropagation(),e.$listeners.onContainerInfoHover(e.order)}}},[e._v(e._s(t.value.notes))]):e._e()])]:e._e()],2)]]:e._e()]})),e.order.speedFlowRate&&0===e.order.childs.length?r("a-tooltip",{attrs:{placement:"top",title:e.$t("滴速")+":"+e.order.speedFlowRate+" "+e.order.speedFlowUnit}},[r("div",{staticClass:"orderArcimDesc_speedFlowWrapper",style:{position:"relative",top:"-19px",left:e.wrapperLeft}},[r("span",{staticClass:"orderArcimDesc_speedFlowRate"},[e._v("\n            "+e._s(e.order.speedFlowRate)+"\n          ")]),r("i",{staticClass:"orderArcimDesc_speedFlowIcon fa fa-tint"}),r("span",{staticClass:"orderArcimDesc_speedFlowUnit"},[e._v("\n            "+e._s(e.order.speedFlowUnit)+"\n          ")])])]):e._e()],2)]),e._l(e.order.childs,(function(t,s){return[r("span",{directives:[{name:"show",rawName:"v-show",value:!t.orcatDesc||String(t.orcatDesc).indexOf("草药")<0,expression:"\n        child.orcatDesc ? String(child.orcatDesc).indexOf('草药') < 0 : true\n      "}],key:s,class:["orderArcimDesc_childOrder",{orderArcimDesc_childOrderBind:""!==t.ifBind}],style:{width:t.speedFlowRate&&s===e.order.childs.length-1?e.colWidth-20+"px":"auto;"}},[e._v("\n      "+e._s(t[e.code])+"\n      "),e._l(t.ordAddInfoValueList,(function(s,a){return["ALL"===s.itemShowMode||e.orderShowMode&&"OrdExec"===s.itemShowMode||!e.orderShowMode&&"Ord"===s.itemShowMode?[r("span",{key:"addInfoItemSub"+a,style:{backgroundColor:s.backgroundColor,color:s.fontColor,"font-size":"ordPriorNotes"===s.key?"10px":"14px"}},[e._v(e._s(e.$t(e.getSubAddInfoValue(e.order,t,s)))+"\n          ")])]:e._e()]})),t.price&&t.doseQtyUnit&&""!==t.price&&""!==t.doseQtyUnit?r("span",{staticClass:"orderArcimDesc_orderPrice"},[e._v(e._s(t.price)+"×"+e._s(t.doseQtyUnit))]):e._e(),t.speedFlowRate&&s===e.order.childs.length-1?r("a-tooltip",{attrs:{placement:"top",title:e.$t("滴速")+":"+t.speedFlowRate+" "+t.speedFlowUnit}},[r("div",{staticClass:"orderArcimDesc_speedFlowWrapper",style:{left:e.wrapperLeft}},[r("span",{staticClass:"orderArcimDesc_speedFlowRate"},[e._v("\n            "+e._s(t.speedFlowRate)+"\n          ")]),r("i",{staticClass:"orderArcimDesc_speedFlowIcon fa fa-tint"}),r("span",{staticClass:"orderArcimDesc_speedFlowUnit"},[e._v("\n            "+e._s(t.speedFlowUnit)+"\n          ")])])]):e._e()],2)]})),e._l(e.order.sameLabNoOrders,(function(t,s){return r("span",{key:"sameLabNoOrders"+t.ID+s,class:["orderArcimDesc_childOrder",{orderArcimDesc_childOrderBind:""!==t.ifBind}]},[e._v("\n    "+e._s(t[e.code])+"\n  ")])})),r("order-time-chart",e._g(e._b({attrs:{order:e.order,timeChartVisible:e.timeChartVisible},on:{orderTimeChartShow:e.orderTimeChartShow}},"order-time-chart",e.$attrs,!1),e.$listeners))],2)},a=[],o=(r("28a5"),r("ac6a"),function(){var e=this,t=e.$createElement,r=e._self._c||t;return e.showOrderExecInfos&&e.showOrderExecInfos.length>0&&e.timeChartVisible?r("div",{class:["orderTimeChart",{"is-show":e.timeChartVisible}]},[r("div",{staticStyle:{height:"50px"}},[r("a-button",{staticStyle:{padding:"0 26px 0 0"},attrs:{type:"link",size:"small"},on:{click:function(t){return t.stopPropagation(),e.$listeners.attachOrderClick(e.order)}}},[e._v("\n      "+e._s(e.$t("绑定"))+"\n    ")]),e._l(e.order.sttDates,(function(t,s){return r("span",{key:s,staticClass:"orderTimeChart_dateSpan",class:["dateSpanIndex-"+e.order.ID+"-"+s]},[e._v("\n      "+e._s(t)+"\n    ")])}))],2),e._l(e.order.sttTimes,(function(t,s){return r("div",{key:s,staticStyle:{height:"50px"}},[r("span",{staticClass:"orderTimeChart_timeSpan"},[e._v("\n      "+e._s(t)+"\n    ")])])})),e._l(e.showOrderExecInfos,(function(t,s){return[r("a-tooltip",{key:"execInfoTip"+s,attrs:{placement:"rightTop",overlayClassName:"execInfo_attorder"}},[r("template",{slot:"title"},[e._l(t.attOrder,(function(t){return e._l(t,(function(t,s){return r("p",{key:s},[e._v("\n            "+e._s(t)+"\n          ")])}))}))],2),r("a-checkbox",{key:"excInfoID"+s,staticClass:"orderTimeChart_execCheckBox",class:e.getExecCheckClass(t),style:e.getExecCheckStyle(t),attrs:{checked:t.check},on:{change:function(r){e.$listeners.onOrderTimeChartChecked(e.orderItemIndex,e.order.execInfos.findIndex((function(e){return t.ID==e.ID})))}},nativeOn:{click:function(t){return e.orderTimeChartShow.apply(null,arguments)}}},[t.examInfo?[t.examInfo.partDesc?r("span",{staticClass:"orderTimeChart_examName",class:e.getExecPartClass(t)},[e._v("\n            "+e._s(t.examInfo.partDesc)+"\n          ")]):e._e(),t.examInfo.partRemark?r("span",{staticClass:"orderTimeChart_examRemark"},[e._v("\n            "+e._s(t.examInfo.partRemark)+"\n          ")]):e._e()]:e._e(),r("div",{staticClass:"orderTimeChart_additionInfo",on:{mouseover:function(r){r.stopPropagation(),e.execConfig.bindOrdDetailFlag&&e.$listeners.onOrderExecHover(e.order,t)}}},[e.execConfig.caShowFlag?r("span",{staticStyle:{width:"30px",height:"30px"},style:"Y"===t.ordExecCA?"background: url("+e.publicPath+"ca_icon.png) no-repeat 4px center":e.getDisplayStyle(t,"ordExecCA","N")}):e._e(),e.execConfig.printFlag?r("span",{staticStyle:{color:"#409EFF",width:"40px"},style:e.getDisplayStyle(t,"printFlag",""),attrs:{title:t.printFlag}},[e._v("\n            "+e._s(String(t.printFlag).split("-").join(""))+"\n          ")]):e._e(),e.execConfig.dspStat?r("span",{staticStyle:{color:"#2a3950",width:"45px"},style:e.getDisplayStyle(t,"dspStat","")},[e._v("\n            "+e._s(t.dspStat)+"\n          ")]):e._e(),!e.execConfig.jpShowFlag||"JP"!==t.filteFlagExtend&&"静配"!==t.filteFlagExtend?e._e():r("span",{staticStyle:{color:"#9400d3"},style:e.getDisplayStyle(t,"filteFlagExtend","")},[e._v("\n            "+e._s(e.$t("静配"))+"\n          ")]),e.execConfig.execTimes?r("span",{staticStyle:{color:"#e0495a",width:"30px"},style:e.getDisplayStyle(t,"freqNo","")},[e._v(e._s(t.freqNo))]):e._e(),r("div",{class:["orderTimeChart_execInfo",e.getDisposeStateColor(t.disposeStatCode)],style:"color:"+e.stateTagList[t.disposeStatCode].color},[r("span",[e._v(" "+e._s(t.execCtcpDesc))]),r("span",[e._v(" "+e._s(t.execDateTime)+" ")])])])],2)],2)]})),e.orderAttachOrderID===e.order.ID?r("order-attach",e._g(e._b({attrs:{order:e.order}},"order-attach",e.$attrs,!1),e.$listeners)):e._e()],2):e._e()}),n=[],i=(r("20d6"),function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("a-modal",{class:["orderattach",{orderattachlite:"lite"===e.$attrs.HISUIStyleCode}],attrs:{centered:"",destroyOnClose:!0,closable:!1,maskClosable:!1},on:{cancel:e.close},model:{value:e.modalVisible,callback:function(t){e.modalVisible=t},expression:"modalVisible"}},[r("template",{slot:"title"},[r("span",{style:{background:"url("+e.publicPath+"white_exec.png) no-repeat 0 2px","padding-left":"26px"}},[e._v(e._s(e.$t("绑定医嘱")))]),r("a",{staticClass:"r-btn-close",style:{"background-image":"url("+e.publicPath+"panel_tools_2.png)","background-repeat":"no-repeat","background-position":"-16px 0"},on:{click:e.close}})]),r("template",{slot:"footer"},[r("a",{staticClass:"orderattach-btn l-btn-text",on:{click:e.save}},[e._v(e._s(e.$t("确定")))]),r("a",{staticClass:"orderattach-btn l-btn-text",staticStyle:{"margin-left":"20px"},on:{click:e.close}},[e._v(e._s(e.$t("取消")))])]),r("a-form",[r("a-row",{attrs:{type:"flex",justify:"center"}},[r("a-col",{attrs:{span:20}},[r("a-form-item",[r("a-radio-group",{on:{change:e.typeRadioChange},model:{value:e.typeRadio,callback:function(t){e.typeRadio=t},expression:"typeRadio"}},[r("a-radio",{attrs:{value:"10"}},[e._v(e._s(e.$t("首次")))]),r("a-radio",{attrs:{value:"11"}},[e._v(e._s(e.$t("接瓶")))])],1)],1),r("a-form-item",[r("a-checkbox",{attrs:{indeterminate:e.isIndeterminate},on:{change:e.handleCheckAllChange},model:{value:e.checkAll,callback:function(t){e.checkAll=t},expression:"checkAll"}},[e._v("\n            "+e._s(e.$t("全选"))+"\n          ")])],1),r("a-form-item",[r("a-checkbox-group",{on:{change:e.handleCheckedAttachOrdersChange},model:{value:e.checkedAttachOrders,callback:function(t){e.checkedAttachOrders=t},expression:"checkedAttachOrders"}},[r("a-row",[e._l(e.attachOrders,(function(t,s){return[r("a-col",{key:s,attrs:{span:24}},[r("a-checkbox",{attrs:{value:t.ArcimId}},[e._v("\n                    "+e._s(t.ArcimDesc)+"\n                  ")])],1)]}))],2)],1)],1),r("div",{staticClass:"orderAttach_footerTitle"},[e._v(e._s(e.$t("是否确认绑定")))])],1)],1)],1)],2)}),c=[],d=r("365c"),l=r("7903"),h={name:"orderAttach",props:["order","orderAttachVisible","defaultAttachTypeRadio"],components:{},data:function(){return{typeRadio:"10",modalVisible:this.orderAttachVisible,attachOrders:[],checkedAttachOrders:[],checkAll:!1,isIndeterminate:!1,publicPath:"".concat("../","images/uiimages/")}},created:function(){},watch:{orderAttachVisible:function(e){this.modalVisible=e,e?this.getAttachOrders(this.typeRadio):(this.checkedAttachOrders=[],this.typeRadio="10",this.attachOrders=[],this.checkedAttachOrders=[])},attachOrders:function(){var e=this;this.attachOrders.forEach((function(t){e.checkedAttachOrders.push(t.ArcimId)}))},defaultAttachTypeRadio:function(e){this.modalVisible&&e&&e!==this.typeRadio&&(this.typeRadio=e,this.getAttachOrders(this.typeRadio))}},methods:{getAttachOrders:function(e){var t=this;d["a"].ajax(l["a"].getAttachOrder,this.order.ID,e).then((function(e){t.attachOrders=e,t.attachOrders.length>0&&(t.checkAll=!0)}))},typeRadioChange:function(){this.attachOrders=[],this.checkedAttachOrders=[],this.getAttachOrders(this.typeRadio),console.log(this.typeRadio)},handleCheckAllChange:function(e){var t=this;e.target.checked?this.attachOrders.forEach((function(e){t.checkedAttachOrders.push(e.ArcimId)})):this.checkedAttachOrders=[],this.isIndeterminate=!1},handleCheckedAttachOrdersChange:function(e){var t=e.length;this.checkAll=t>0&&t===this.checkedAttachOrders.length,this.isIndeterminate=t>0&&t<this.attachOrders.length},save:function(){this.$emit("saveAttachOrder",{order:this.order,attachOrders:this.attachOrders,checkedAttachOrders:this.checkedAttachOrders})},close:function(){this.$emit("closeOrderAttach")}}},u=h,p=(r("1761"),r("2877")),m=Object(p["a"])(u,i,c,!1,null,"7cffb726",null),f=m.exports,g={name:"orderTimeChart",props:["order","timeChartVisible","orderItemIndex","orderAttachOrderID","stateTagList","excuteFlag","execConfig"],components:{orderAttach:f},data:function(){return{publicPath:"".concat("../","images/uiimages/")}},inheritAttrs:!1,computed:{showOrderExecInfos:function(){var e=[];return this.order.execInfos&&(e=this.order.execInfos.filter((function(e){return e.show}))),e}},methods:{getExecCheckClass:function(e){var t=this.order.sttDates.findIndex((function(t){return e.sttDate===t}));return["is-".concat(e.disposeStatCode),"dateIndex-".concat(this.order.ID,"-").concat(t)]},getExecPartClass:function(e){var t=this.order.sttDates.findIndex((function(t){return e.sttDate===t}));return["execPartIndex-".concat(this.order.ID,"-").concat(t)]},orderTimeChartShow:function(){this.$emit("orderTimeChartShow",!0)},getDisposeStateColor:function(e){var t=this;return this.$nextTick((function(){for(var r=".is-".concat(e,"> .ant-checkbox > .ant-checkbox-inner"),s=document.querySelectorAll(r),a=0;a<s.length;a++)s[a].style.backgroundColor=t.stateTagList[e].color,s[a].style.borderColor=t.stateTagList[e].color})),"is-".concat(e)},getExecCheckStyle:function(e){var t=this,r=this.order.sttDates.findIndex((function(t){return e.sttDate===t})),s=this.order.sttTimes.findIndex((function(t){return e.sttTime===t})),a=50*(s+1)+10,o=270*r+70;return this.$nextTick((function(){var r=t.order.sttDates.findIndex((function(t){return e.sttDate===t}));t.reSetAdditionInfoLeft(r);var s=0;if(r>0){var a=document.getElementsByClassName("dateIndex-"+t.order.ID+"-"+(r-1));if(a.length>0){for(var o=0;o<a.length;o++){var n=parseInt(a[o].offsetWidth);n>s&&(s=n)}s=s+parseInt(a[0].style.left)-40}else for(var i=0;i<r;i++){var c=document.getElementsByClassName("dateSpanIndex-"+t.order.ID+"-"+(r-1));s+=parseInt(c[0].offsetWidth)}}for(var d=s+70,l=document.getElementsByClassName("dateIndex-"+t.order.ID+"-"+r),h=0;h<l.length;h++)l[h].style.left="".concat(d,"px");t.reSetDateSpansWidth(r)})),{position:"absolute",top:"".concat(a,"px"),left:"".concat(o,"px")}},getDisplayStyle:function(e,t,r){var s=this.order.execInfos.findIndex((function(s){return!(s[t]===r||!s[t])&&s.sttDate===e.sttDate}));return s>=0?"":"display:none;"},reSetDateSpansWidth:function(e){for(var t=0,r=document.getElementsByClassName("dateIndex-"+this.order.ID+"-"+e),s=0;s<r.length;s++){var a=parseInt(r[s].offsetWidth);a>t&&(t=a)}t+=30;for(var o=document.getElementsByClassName("dateSpanIndex-"+this.order.ID+"-"+e),n=0;n<o.length;n++)o[n].style.width="".concat(t,"px")},reSetAdditionInfoLeft:function(e){var t=document.getElementsByClassName("execPartIndex-"+this.order.ID+"-"+e);if(t.length>0){for(var r=0,s=0;s<t.length;s++){var a=parseInt(t[s].offsetWidth);a>r&&(r=a)}r+=20;for(var o=document.getElementsByClassName("dateIndex-"+this.order.ID+"-"+e),n=0;n<o.length;n++)o[n].children[1].childNodes.length>2&&(r+=parseInt(o[0].children[1].childNodes[1].offsetWidth)),o[n].children[1].lastChild.style.left="".concat(r,"px")}}}},S=g,v=(r("3af4"),r("43b2"),r("53c9"),Object(p["a"])(S,o,n,!1,null,"2f14f03b",null)),N=v.exports,x={name:"orderArcimDesc",props:["order","code","index","orderShowMode","colWidth"],components:{orderTimeChart:N},inheritAttrs:!1,data:function(){return{timeChartVisible:!!this.$attrs.execConfig.ordExecFoldFlag,isClickTarget:!1,visible:!1,wrapperLeft:100}},created:function(){var e=this;this.$nextTick((function(){var t=document.getElementsByClassName("orderArcimDesc")[0].offsetWidth;e.wrapperLeft=t-20+"px"}))},watch:{},computed:{skinTestColor:function(){var e="is-skinTest";if("Y"===this.order.abnorm?e="is-skinTest":"N"===this.order.abnorm&&(e="is-skinNorm"),this.order.childs.length>0){var t=this.order.childs.some((function(e){return"N"===e.abnorm})),r=this.order.childs.some((function(e){return"Y"===e.abnorm}));r&&(e="is-skinTest"),t&&(e="is-skinNorm")}return e},printFlags:function(){var e=this.order,t=[];return e.execInfos&&e.execInfos.forEach((function(e){(String(e.printFlag).indexOf("P")>-1||String(e.printFlag).indexOf("B")>-1)&&t.indexOf("条码已打")<0&&t.push("条码已打")})),t}},methods:{handleVisibleChange:function(e){this.visible=e},getSkinTestText:function(e){var t="皮";if("Y"===e.abnorm?t="阳":"N"===e.abnorm&&(t="阴"),e.childs.length>0){var r=e.childs.some((function(e){return"N"===e.abnorm})),s=e.childs.some((function(e){return"Y"===e.abnorm}));s&&(t="阳"),r&&(t="阴")}return t},ifOecprDesc:function(e){var t=["自备药即刻","自备药长期","取药医嘱","长期嘱托","临时嘱托"];return t.indexOf(e.oecprDesc)>-1},ifIPDosing:function(e){var t=!1;return this.orderShowMode?"JP"===e.filteFlagExtend||"静配"===e.filteFlagExtend?(t=!0,t):t:(e.execInfos&&e.execInfos.forEach((function(e){return"JP"===e.filteFlagExtend||"静配"===e.filteFlagExtend?(t=!0,t):t})),t)},getAddInfoValue:function(e,t){var r=t.value;return""===r&&e.execInfos&&!this.orderShowMode&&e.execInfos.forEach((function(e){e.ordAddInfoValueList.forEach((function(e){if(e.key===t.key&&""!==e.value)return r=e.value,r}))})),r},getSubAddInfoValue:function(e,t,r){var s=t.ID,a=r.value;if(""===a)if(e.execInfos&&!this.orderShowMode)e.execInfos.forEach((function(e){e.childsexecInfos.forEach((function(e){var t=e.ID;t.split("||")[0]+"||"+t.split("||")[1]===s&&e.ordAddInfoValueList.forEach((function(e){if(e.key===r.key&&""!==e.value)return a=e.value,a}))}))}));else if(e.childsexecInfos&&this.orderShowMode){var o=e.childsexecInfos[0].ordAddInfoValueList;o&&o.forEach((function(e){if(e.key===r.key&&""!==e.value)return a=e.value,a}))}return a},toggleTimeChartShow:function(){this.timeChartVisible=!this.timeChartVisible,this.isClickTarget?(this.timeChartVisible=!0,this.isClickTarget=!1):this.$listeners.onOrderItemClickCell(this.$attrs.orderItemIndex,this.order.ID,this.timeChartVisible)},orderTimeChartShow:function(e){this.isClickTarget=e},getOrdBackgroundColor:function(){var e=this.order.backgroundColor;return!e&&this.order.childs&&this.order.childs.forEach((function(t){return t.backgroundColor?(e=t.backgroundColor,e):e})),{background:e||""}},getMainOrderArcimDescStyle:function(){var e=this.colWidth;return this.order.emergency&&(e-=50),void 0!==this.order.abnorm&&(e-=50),this.order.childs&&this.order.childs.length>0&&this.order.speedFlowRate&&0===this.order.childs.length&&(e-=20),{width:e+"px"}}}},C=x,_=(r("6e1b"),Object(p["a"])(C,s,a,!1,null,"0d17dd3f",null));t["default"]=_.exports},"9d4a":function(e,t,r){},bbe1:function(e,t,r){},d4de:function(e,t,r){}}]);
//# sourceMappingURL=chunk-67634daa.23483f32.js.map