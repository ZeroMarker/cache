webpackJsonp([199],{sBzG:function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var a=n("Dd8w"),o=n.n(a),l=n("NYxO"),i={name:"PersonStructure",computed:o()({},Object(l.b)(["Height","styleCode"])),data:function(){return{labelClassName:"bg-color-orange",basicInfo:{id:null,label:null},basicSwitch:!1,treeData:{id:0,label:"护理部"},pattForm:{Pattern:!0},pattStore:[{label:"水平",value:!0},{label:"垂直",value:!1}]}},created:function(){this.loadData()},methods:{loadData:function(){var e=this,t=e.axiosConfig("web.INMHRComm","GetPersonStructData","Method");e.$ajax.request(t).then(function(t){e.treeData=t.data})},renderContent:function(e,t){return e("div",[e("div",{style:"padding-bottom:10px;"},[e("i",{class:"el-icon-user-solid"}),e("span",[t.label]),e("span",["(",t.sum,")"])]),e("div",{style:"font-size:12px;height:20px;line-height:20px;background:#fff;color:#000;padding:5px 0;"},[t.nurhead])])},onMouseout:function(e,t){this.basicSwitch=!1},onMouseover:function(e,t){this.basicInfo=t,this.basicSwitch=!0},NodeClick:function(e,t){this.toggleExpand(t,!0)},collapse:function(e){var t=this;e.forEach(function(e){e.expand&&(e.expand=!1),e.children&&t.collapse(e.children)})},onExpand:function(e,t){"expand"in t?(t.expand=!t.expand,!t.expand&&t.children&&this.collapse(t.children)):this.$set(t,"expand",!0)},toggleExpand:function(e,t){var n=this;Array.isArray(e)?e.forEach(function(e){n.$set(e,"expand",t),e.children&&n.toggleExpand(e.children,t)}):(this.$set(e,"expand",t),e.children&&n.toggleExpand(e.children,t))}}},r={render:function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"person-structure-panel",staticStyle:{height:"680px"}},[n("div",{staticClass:"top-tool-inputDiv"},[n("el-form",{attrs:{model:e.pattForm,inline:"","label-width":"80px"}},[n("el-form-item",[n("el-select",{staticStyle:{width:"120px"},attrs:{clearable:"",filterable:"",size:"mini",placeholder:"请选择"},model:{value:e.pattForm.Pattern,callback:function(t){e.$set(e.pattForm,"Pattern",t)},expression:"pattForm.Pattern"}},e._l(e.pattStore,function(e){return n("el-option",{key:e.value,attrs:{label:e.label,value:e.value}})}),1)],1)],1)],1),e._v(" "),n("div",{style:{height:e.Height-90+"px"}},[n("vue2-org-tree",{staticStyle:{width:"100%","overflow-x":"auto",height:"100%"},attrs:{data:e.treeData,horizontal:e.pattForm.Pattern,collapsable:!1,renderContent:e.renderContent,"label-class-name":e.labelClassName},on:{"on-expand":e.onExpand,"on-node-click":e.NodeClick,"on-node-mouseover":e.onMouseover,"on-node-mouseout":e.onMouseout}})],1)])},staticRenderFns:[]};var s=n("VU/8")(i,r,!1,function(e){n("zyFR")},null,null);t.default=s.exports},zyFR:function(e,t){}});