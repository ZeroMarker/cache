webpackJsonp([174],{gUiP:function(e,t,o){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=o("pFYg"),a=o.n(n),s=o("Dd8w"),r=o.n(s),l=o("NYxO"),i=o("z8xk"),c=o("XlQt"),d={components:{hgpanel:i.default,hgbutton:c.default},name:"WorkLoadDepSet",computed:r()({},Object(l.b)(["Height","styleCode"])),created:function(){this.loadCheckWard(!0)},data:function(){return{typestores:[{id:"W",label:"病区"},{id:"O",label:"门诊"},{id:"E",label:"急诊"},{id:"OP",label:"手术室"},{id:"N",label:"医技科室"}],elrowstyle:{height:"20px"},pagesize:20,currentPage:1,totalCount:0,setwardstore:[],checkwardstore:[],sysward:"",workDepForm:{fuzzyward:""},setSelection:[],checkSelection:[],rowSelection:"",rowType:""}},methods:{isSelectSetWard:function(e,t){var o=1,n=e.wardid;if(this.checkwardstore)for(var a=0;a<this.checkwardstore.length;a++){if(this.checkwardstore[a].WardID)this.checkwardstore[a].WardID==n&&(o=0)}return o},loadSetWardStore:function(){var e=this,t=e.sysward;t||(t=""),e.setwardstore=new Array,e.$ajax.request(e.axiosConfig("web.INMStatComm","FindMgWard","RecQuery","start$0","limit$1000","input$"+t)).then(function(t){e.$nextTick(function(){e.setwardstore=t.data.rows})})},moveLeft:function(){for(var e=this,t="",o=0;o<e.checkSelection.length;o++)a()("object"==e.checkSelection[o])&&(t=t?t+"^"+e.checkSelection[o].RowID:e.checkSelection[o].RowID);t?e.$ajax.request(e.axiosConfig("web.INMStatComm","DeleteWorkLoadDepSet","Method","parr$"+t)).then(function(t){1==t.data?e.$message({showClose:!0,type:"success",message:"操作成功！"}):e.$message({showClose:!0,type:"success",message:"操作失败！"}),e.loadCheckWard(!0)}):e.$message({showClose:!0,type:"warning",message:"请选择检查病区！"})},moveRight:function(){for(var e=this,t="",o=0;o<e.setSelection.length;o++)a()("object"==e.setSelection[o])&&(t=t?t+"^"+e.setSelection[o].wardid+"|"+e.setSelection[o].wardType:e.setSelection[o].wardid+"|"+e.setSelection[o].wardType);t?e.$ajax.request(e.axiosConfig("web.INMStatComm","SaveWorkLoadDepSet","Method","parr$"+t)).then(function(t){1==t.data&&(e.$message({showClose:!0,type:"success",message:"操作成功！"}),e.loadCheckWard(!0))}):e.$message({showClose:!0,type:"warning",message:"请选择系统病区！"})},setSelectionChange:function(e){this.setSelection=e},checkSelectionChange:function(e){this.checkSelection=e},loadCheckWard:function(e){var t=this,o=t.workDepForm.fuzzyward;t.checkwardstore=new Array,t.$ajax.request(t.axiosConfig("web.INMStatComm","getWorkLoadDepSet","RecQuery","start$0","limit$1000","input$"+o)).then(function(o){t.$nextTick(function(){t.checkwardstore=o.data.rows,t.rowSelection="",e&&t.loadSetWardStore()})})},rowSelectEvent:function(e,t,o){this.rowSelection=e.RowID,this.rowType=e.WardType},moveRec:function(e){var t=this;t.rowSelection?t.$ajax.request(t.axiosConfig("web.INMStatComm","MoveWorkLoadDepSet","Method","type$"+e,"rowid$"+t.rowSelection)).then(function(e){0==e.data?t.loadCheckWard(!1):t.$message({showClose:!0,type:"warning",message:e.data})}):t.$message({type:"warning",message:"请选择要移动的行(不是选择框选中,单击行，背景色变色即可)",showClose:!0,customClass:"warning_class"})}}},h={render:function(){var e=this,t=e.$createElement,o=e._self._c||t;return o("div",{staticClass:"work-load-depset-panel"},[o("el-row",{staticStyle:{padding:"10px 12px 10px 10px"},attrs:{gutter:10}},[o("el-col",{attrs:{span:11}},[o("hgpanel",{staticStyle:{width:"100%"},attrs:{title:e.$t("menu.WorkLoadDepSet.5nrnccwos0g0"),styleCode:e.styleCode,icon:"#nm-icon-paper",panelHeight:e.Height-31}},[o("div",{staticClass:"panel-button-space",attrs:{slot:"tool"},slot:"tool"},[o("el-input",{staticStyle:{width:"140px"},attrs:{size:"mini","suffix-icon":e.styleCode?"nm-icon-w-find":"nm-icon-lite-search",placeholder:e.$t("menu.WorkLoadDepSet.5nrnccwpms00")},nativeOn:{keyup:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.loadSetWardStore(t)}},model:{value:e.sysward,callback:function(t){e.sysward=t},expression:"sysward"}})],1),e._v(" "),o("div",{staticClass:"top-tool-table"},[o("el-table",{ref:"setwardstore",staticClass:"dialog-table-bottom-radius",staticStyle:{width:"100%","border-bottom":"0"},attrs:{data:e.setwardstore,"row-style":e.elrowstyle,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":!0,border:e.styleCode,height:e.Height-118},on:{"selection-change":e.setSelectionChange}},[o("el-table-column",{attrs:{type:"index",width:"40",align:"center"}}),e._v(" "),o("el-table-column",{attrs:{type:"selection",width:"55",selectable:e.isSelectSetWard,align:"center"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.WorkLoadDepSet.5nrnccwqhok0"),prop:"warddesc"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.WorkLoadDepSet.5nrnccwrcxc0"),prop:"wardType",width:"60"}}),e._v(" "),e._e()],1)],1)])],1),e._v(" "),o("el-col",{attrs:{span:2}},[o("div",{staticClass:"bottom-button",staticStyle:{width:"100%",margin:"0 auto"},style:{height:parseInt(e.Height-67)+"px"}},[o("div",{staticStyle:{"text-align":"center","padding-bottom":"20px"},style:{"padding-top":parseInt((e.Height-67)/2)+"px"}},[o("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,disabled:!e.setSelection||0==e.setSelection.length},on:{click:function(t){return e.moveRight()}}},[o("i",{class:e.styleCode?"el-icon-arrow-right":"nm-icon-lite-right-arrow"})])],1),e._v(" "),o("div",{staticStyle:{"text-align":"center"}},[o("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,disabled:!e.checkSelection||0==e.checkSelection.length},on:{click:function(t){return e.moveLeft()}}},[o("i",{class:e.styleCode?"el-icon-arrow-left":"nm-icon-lite-left-arrow"})])],1)])]),e._v(" "),o("el-col",{attrs:{span:11}},[o("hgpanel",{staticStyle:{width:"100%"},attrs:{title:e.$t("menu.WorkLoadDepSet.5ncy6xyvfdc0"),styleCode:e.styleCode,icon:"#nm-icon-paper",panelHeight:e.Height-31}},[o("div",{attrs:{slot:"tool"},slot:"tool"},[o("div",{staticClass:"top-tool-inputDiv"},[o("el-form",{attrs:{model:e.workDepForm,inline:!0,align:"left"},nativeOn:{submit:function(e){e.preventDefault()}}},[o("el-form-item",[o("el-input",{staticStyle:{width:"140px"},attrs:{"suffix-icon":e.styleCode?"nm-icon-w-find":"nm-icon-lite-search",placeholder:e.$t("menu.WorkLoadDepSet.5nrnccws9k40"),size:"mini"},nativeOn:{keyup:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.loadCheckWard()}},model:{value:e.workDepForm.fuzzyward,callback:function(t){e.$set(e.workDepForm,"fuzzyward",t)},expression:"workDepForm.fuzzyward"}})],1)],1)],1),e._v(" "),o("div",{staticClass:"top-tool-button"},[o("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-to-up":"nm-icon-lite-up"},on:{click:function(t){return e.moveRec("up")}}},[e._v(e._s(e.$t("menu.WorkLoadDepSet.5nrnccwsang0")))]),e._v(" "),o("hgbutton",{attrs:{type:"text",issvg:e.styleCode,icon:e.styleCode?"#nm-icon-to-down":"nm-icon-lite-down"},on:{click:function(t){return e.moveRec("down")}}},[e._v(e._s(e.$t("menu.WorkLoadDepSet.5nrnccwsaz40")))])],1)]),e._v(" "),o("div",{staticClass:"top-tool-table word-dep-table dialog-table-bottom-radius"},[o("el-table",{ref:"checkwardstore",staticStyle:{width:"100%"},attrs:{data:e.checkwardstore,"header-cell-style":e.headerCellFontWeight,"row-style":e.elrowstyle,"highlight-current-row":!0,border:e.styleCode,height:e.Height-156},on:{"selection-change":e.checkSelectionChange,"row-click":e.rowSelectEvent}},[o("el-table-column",{attrs:{type:"index",width:"40",align:"center"}}),e._v(" "),o("el-table-column",{attrs:{type:"selection",width:"55",align:"center"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.WorkLoadDepSet.5nrnccwqhok0"),prop:"WardDesc"}}),e._v(" "),o("el-table-column",{attrs:{label:e.$t("menu.WorkLoadDepSet.5nrnccwrcxc0"),prop:"WardType",width:"80"}}),e._v(" "),e._e(),e._v(" "),e._e(),e._v(" "),e._e()],1)],1)])],1)],1)],1)},staticRenderFns:[]};var u=o("VU/8")(d,h,!1,function(e){o("iGQy")},null,null);t.default=u.exports},iGQy:function(e,t){}});