webpackJsonp([271],{"2iQB":function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=a("Gu7T"),o=a.n(s),l=a("Dd8w"),r=a.n(l),i=a("NYxO"),n=a("z8xk"),m=a("XlQt"),c=a("W5Fe"),d={components:{hgpanel:n.default,hgbutton:m.default,hgpagination:c.default},name:"SpecialReAdm",computed:r()({},Object(i.b)(["Height","styleCode"])),data:function(){return{elementlist:{},ToolForm:{Group:""},GroupStore:[],AdmItem:[{label:"专科再认证总纲",children:[],itemDesc:"",itemStandard:"",optionValue:[],way:"",className:"",methodName:"",param:[],column:["ItemCode#认证项目","ItemDesc#说明","ItemStandard#评分标准","AdmScore#评分","AdmPassDesc#结果"],index:-1,rw:"root"}],SelectPerRow:{},TableData:[],CurrentPage:1,PageSize:20,TotalCount:0,AdmLoading:!1,AdmTable:[],SelectAdmRow:{},DialogVisible:!1,AdmForm:{Per:"",Score:[],Pass:[],PassDesc:[],rw:""},AdmItemLoading:!1,SelectItem:{},AccordTable:[],AdmEnable:!1,ReAdmType:""}},methods:{AdmFormPassChange:function(e){var t="";t="Y"==this.AdmForm.Pass[e]?"通过":"未通过",this.AdmForm.PassDesc[e]=t},LoadAdmItem:function(){var e=this;this.AdmItem[0].children=[];var t=this.axiosConfig("web.INMDBComm","FindReAdmItemList","RecQuery");this.$ajax.request(t).then(function(t){t.data instanceof Object?t.data.rows.filter(function(e){return"Y"==e.ItemStatus}).forEach(function(t,a){var s=t.ItemOptionValue?t.ItemOptionValue.split("」"):[],o=t.ItemResult.split("|"),l=o[0],r=o[1]?o[1].split("ˇ"):[],i=r[2];if(i){var n=i.match(/UPPARAM\d/g);n&&n.forEach(function(e){var t=parseInt(e.replace("UPPARAM",""));isNaN(t)||(i=i.replace(e,s[t]))});var m=i.match(/sessionStorage\.\S+?([&\*]|$)/g);m&&m.forEach(function(e){var t=e.replace(/[&\*]$/,""),a=t.replace("sessionStorage.","");i=i.replace(t,sessionStorage[a])}),i=i.replace(/#/g,"$").replace(/&/g,"^").split("*")}else i=[];e.AdmItem[0].children.push({label:t.ItemCode,itemDesc:t.ItemDesc,itemStandard:t.ItemStandard,optionValue:s,way:l,className:r[0],methodName:r[1],param:i,column:r[3]?r[3].split("&"):[],index:a,rw:t.rw})}):e.$message({type:"error",message:"获取认证项目列表失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取认证项目列表失败",showClose:!0,customClass:"error_class"})})},LoadGroupNurse:function(){var e=this,t=(this.CurrentPage-1)*this.PageSize,a=this.PageSize;this.TableData=[];var s=this.axiosConfig("web.INMSpecialComm","FindSingleMemberList","RecQuery","parr$"+this.ToolForm.Group,"start$"+t,"limit$"+a);this.$ajax.request(s).then(function(t){t.data instanceof Object?(e.TableData=t.data.rows,e.TotalCount=parseInt(t.data.results)):e.$message({type:"error",message:"获取专业组成员列表失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取专业组成员列表失败",showClose:!0,customClass:"error_class"})})},PerRowClick:function(e){this.SelectPerRow=e,this.LoadPerAdmData()},LoadPerAdmData:function(){var e=this;this.AdmTable=[],this.AdmLoading=!0;var t=this.axiosConfig("web.INMSpecialComm","FindReAdmList","RecQuery","parr$"+this.SelectPerRow.Per);this.$ajax.request(t).then(function(t){e.AdmLoading=!1,t.data instanceof Object?e.AdmTable=t.data.rows:e.$message({type:"error",message:"获取再认证记录列表失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.AdmLoading=!1,e.$message({type:"error",message:"获取再认证记录列表失败",showClose:!0,customClass:"error_class"})})},ResetAdmForm:function(){this.AdmForm={Per:"",Score:new Array(this.AdmItem[0].children.length).fill(""),Pass:new Array(this.AdmItem[0].children.length).fill(""),PassDesc:new Array(this.AdmItem[0].children.length).fill(""),rw:""},this.SelectItem={},this.AccordTable=[]},AdmRowDbClick:function(e){var t=this;this.SelectAdmRow=e,this.ReAdmType="DBCLICK",this.SelectAdmRow.rw?(this.ResetAdmForm(),this.AdmEnable=!1,this.DialogVisible=!0,this.$nextTick(function(){t.LoadAdmContent()})):this.$message({type:"warning",message:"记录不存在",showClose:!0,customClass:"warning_class"})},AddAdm:function(e,t){var a=this;this.SelectAdmRow=e,this.ReAdmType="ADD",0==t?1==e.NeedReAdm?(this.ResetAdmForm(),this.AdmForm.Per=e.Per,this.AdmEnable=!0,this.DialogVisible=!0,this.$nextTick(function(){a.$refs.AdmItemTree.setCurrentKey("root");var e=a.$refs.AdmItemTree.getCurrentNode();a.ItemClick(e)})):this.$message({type:"warning",message:"有效期内无需认证",showClose:!0,customClass:"warning_class"}):this.$message({type:"warning",message:"已存在认证记录",showClose:!0,customClass:"warning_class"})},LoadAdmContent:function(){var e=this;this.AdmItemLoading=!0;var t=this.axiosConfig("web.INMSpecialComm","GetReAdm","RecMethod","id$"+this.SelectAdmRow.rw);this.$ajax.request(t).then(function(t){if(e.AdmItemLoading=!1,t.data instanceof Object){"N"==t.data.AdmStatus||"B"==t.data.AdmStatus?e.AdmEnable=!0:e.AdmEnable=!1,e.AdmForm.Per=t.data.AdmPer,e.AdmForm.Score=t.data.AdmScore.split(","),e.AdmForm.Pass=t.data.AdmPass.split(","),e.AdmForm.PassDesc=t.data.AdmPassDesc.split(","),e.AdmForm.rw=t.data.rw,e.$refs.AdmItemTree.setCurrentKey("root");var a=e.$refs.AdmItemTree.getCurrentNode();e.ItemClick(a)}else e.DialogVisible=!1,e.$message({type:"error",message:"获取记录内容失败",showClose:!0,customClass:"error_class"})}).catch(function(t){e.AdmItemLoading=!1,e.DialogVisible=!1,e.$message({type:"error",message:"获取记录内容失败",showClose:!0,customClass:"error_class"})})},ItemClick:function(e){var t=this;if(this.SelectItem=e,"root"==this.SelectItem.rw)this.AccordTable=this.SelectItem.children.map(function(e,a){return{ItemCode:e.label,ItemDesc:e.itemDesc,ItemStandard:e.itemStandard,AdmScore:t.AdmForm.Score[a],AdmPass:t.AdmForm.Pass[a],AdmPassDesc:t.AdmForm.PassDesc[a]}});else{this.AccordTable=[];var a="",s="";if("ADD"==this.ReAdmType)a=this.SelectAdmRow.AdmDate,s=this.SelectAdmRow.AdmNextDate;else{this.SelectAdmRow;var l=this.AdmTable.findIndex(function(e){return t.SelectAdmRow.rw==e.rw});l>-1&&l<this.AdmTable.length&&(a=this.AdmTable[l+1].AdmDate,s=this.AdmTable[l+1].AdmNextDate)}var r={READMPERID:this.SelectPerRow.Per,READMSTDATE:a,READMENDDATE:s},i=e.param.map(function(e){return e.replace(/READMPERID|READMSTDATE|READMENDDATE/g,function(e){return r[e]?r[e]:""})}),n=this.axiosConfig.apply(this,[e.className,e.methodName,e.way].concat(o()(i)));this.$ajax.request(n).then(function(a){var s=!0;"Method"!=e.way&&"RecMethod"!=e.way||(s=!1),s&&a.data instanceof Object?t.AccordTable=a.data.rows:!s&&a.data instanceof Array?t.AccordTable=a.data:t.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"})}).catch(function(e){t.$message({type:"error",message:"获取数据失败",showClose:!0,customClass:"error_class"})})}},SaveAdm:function(e){var t=this,a=this.AdmForm.Per+"^"+this.AdmForm.Score.join(",")+"^"+this.AdmForm.Pass.join(",")+"^"+e+"^"+this.AdmForm.rw;this.AdmItemLoading=!0;var s=this.axiosConfig("web.INMSpecialComm","SaveReAdm","Method","parr$"+a,"nurseid$"+sessionStorage.loginID);this.$ajax.request(s).then(function(a){t.AdmItemLoading=!1;var s=Number(a.data);!isNaN(s)&&s>0?(t.AdmForm.rw=s,"A"==e&&(t.AdmEnable=!1),t.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"})):t.$message({type:"error",message:"保存失败",showClose:!0,customClass:"error_class"})}).catch(function(e){t.AdmItemLoading=!1,t.$message({type:"error",message:"保存失败",showClose:!0,customClass:"error_class"})})},ReAdmColsed:function(){this.LoadPerAdmData()},HandleSizeChange:function(e){this.PageSize=e,this.ToolFormSearch()},HandleCurrentChange:function(e){this.CurrentPage=e.currentPage,this.ToolFormSearch()}},created:function(){this.LoadAdmItem(),this.loadSysParamSubData("专业组","GroupStore"),this.LoadGroupNurse();var e=this.$router.currentRoute.path.slice(1,this.$router.currentRoute.path.length);this.loadElementsForRouter("elementlist",e)}},u={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"special-readm-panel"},[a("div",[a("el-row",{staticStyle:{padding:"10px 12px 10px 10px"},attrs:{gutter:12}},[a("el-col",{attrs:{span:14}},[a("hgpanel",{staticStyle:{width:"100%"},attrs:{title:e.$t("menu.SpecialReAdm.5ncy6rzathg0"),styleCode:e.styleCode,icon:"#nm-icon-paper",panelHeight:e.Height-31}},[a("div",{staticClass:"top-tool-input",attrs:{slot:"tool"},slot:"tool"},[a("el-form",{attrs:{model:e.ToolForm,inline:!0,"label-position":"left"}},[a("el-form-item",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2xsu340")}},[a("el-select",{staticStyle:{width:"120px"},attrs:{filterable:"",clearable:"",size:"mini"},model:{value:e.ToolForm.Group,callback:function(t){e.$set(e.ToolForm,"Group",t)},expression:"ToolForm.Group"}},e._l(e.GroupStore,function(e){return a("el-option",{key:e.SubValue,attrs:{label:e.SubDesc,value:e.SubValue}})}),1)],1),e._v(" "),a("el-form-item",[a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.LoadGroupNurse}},[e._v(e._s(e.$t("menu.SpecialReAdm.5nrnc2xsvwc0")))])],1)],1)],1),e._v(" "),a("div",{staticClass:"top-tool-table",staticStyle:{"border-bottom-right-radius":"4px","border-bottom-left-radius":"4px"}},[a("el-table",{attrs:{data:e.TableData,"highlight-current-row":"",border:e.styleCode,"header-cell-style":e.headerCellFontWeight,height:e.styleCode?e.Height-151:e.Height-148},on:{"row-click":e.PerRowClick}},[a("el-table-column",{attrs:{type:"index",align:"center",width:"40"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2xwd2o0"),prop:"SubStatusDesc","show-overflow-tooltip":"",width:"80"},scopedSlots:e._u([{key:"default",fn:function(t){return[a("span",{style:"color:"+(t.row.StatusDesc==e.$t("menu.SpecialReAdm.5ncy6rzbu200")?"green;":t.row.StatusDesc==e.$t("menu.SpecialReAdm.5ncy6rzcbe00")?"#409EFF;":"red;")},[e._v(e._s(t.row.StatusDesc))])]}}])}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2xyhi80"),prop:"PerName","show-overflow-tooltip":"",width:"100"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2xzmyc0"),prop:"PerPost","show-overflow-tooltip":"",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2y1qdk0"),prop:"PerLevel","show-overflow-tooltip":"",width:"80"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2y2ulc0"),prop:"PerCurWard","show-overflow-tooltip":"",width:"120"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2y4fj40"),prop:"MemberGroupDesc","show-overflow-tooltip":""}})],1),e._v(" "),a("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.TotalCount,pageNumber:e.CurrentPage,pageSize:e.PageSize},on:{changePage:e.HandleCurrentChange,getPageSize:e.HandleSizeChange}})],1)])],1),e._v(" "),a("el-col",{attrs:{span:10}},[a("hgpanel",{staticStyle:{width:"100%"},attrs:{title:e.$t("menu.SpecialReAdm.5ncy6rzdgq80"),styleCode:e.styleCode,icon:"#nm-icon-paper",panelHeight:e.Height-31}},[a("div",{directives:[{name:"loading",rawName:"v-loading",value:e.AdmLoading,expression:"AdmLoading"}],staticClass:"top-tool-table",staticStyle:{"margin-top":"2px","border-bottom-right-radius":"4px","border-bottom-left-radius":"4px"},attrs:{"element-loading-text":e.$t("menu.SpecialReAdm.5nrnc2y63hg0")}},[a("el-table",{staticStyle:{"border-bottom":"0"},attrs:{data:e.AdmTable,"highlight-current-row":"",border:e.styleCode,"header-cell-style":e.headerCellFontWeight,height:e.Height-70},on:{"row-dblclick":e.AdmRowDbClick}},[a("el-table-column",{attrs:{type:"index",align:"center",width:"40"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2xyhi80"),prop:"PerName","show-overflow-tooltip":"",width:"100"}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2yb36g0"),prop:"AdmDate","show-overflow-tooltip":""}}),e._v(" "),a("el-table-column",{attrs:{label:e.$t("menu.SpecialReAdm.5ncy6rzdia80"),"show-overflow-tooltip":""},scopedSlots:e._u([{key:"default",fn:function(t){return[a("span",{staticStyle:{color:"#409EFF",cursor:"pointer"},on:{click:function(a){return e.AddAdm(t.row,t.$index)}}},[e._v(e._s(t.row.AdmNextDate))])]}}])})],1)],1)])],1)],1)],1),e._v(" "),a("el-dialog",{attrs:{title:e.$t("menu.SpecialReAdm.5nrnc2yco1c0"),visible:e.DialogVisible,"close-on-click-modal":!1,width:"1200px"},on:{"update:visible":function(t){e.DialogVisible=t},closed:e.ReAdmColsed}},[a("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?a("i",{staticClass:"nm-icon-w-paper"}):e._e(),e._v(" "),a("span",[e._v(e._s(e.$t("menu.SpecialReAdm.5nrnc2yco1c0")))])]),e._v(" "),a("div",{directives:[{name:"loading",rawName:"v-loading",value:e.AdmItemLoading,expression:"AdmItemLoading"}],staticStyle:{height:"100%"},attrs:{"element-loading-text":e.$t("menu.SpecialReAdm.5nrnc2y63hg0")}},[a("div",{staticStyle:{border:"1px solid #ccc","border-radius":"4px","font-weight":"blod","padding-left":"10px","background-color":"#f7f7f7",color:"#000","text-align":"left"}},[a("span",{staticStyle:{"line-height":"30px"}},[e._v(e._s(e.SelectPerRow.PerName+"/"+e.SelectPerRow.PerPost+"/"+e.SelectPerRow.PerLevel+"/"+e.SelectPerRow.MemberGroupDesc+"/"+e.SelectPerRow.PerCurWard))])]),e._v(" "),a("div",[a("el-row",{staticStyle:{padding:"0 2px 0 0","margin-top":"10px"},attrs:{gutter:12}},[a("el-col",{attrs:{span:7}},[a("hgpanel",{staticStyle:{width:"100%"},attrs:{title:e.$t("menu.SpecialReAdm.5ncy6rzdlg40"),styleCode:e.styleCode,icon:"#nm-icon-paper",panelHeight:e.Height-127}},[a("div",{style:{height:e.Height-175+"px"}},[a("el-tree",{ref:"AdmItemTree",attrs:{data:e.AdmItem,"node-key":"rw","default-expand-all":"","highlight-current":"","expand-on-click-node":!1},on:{"node-click":e.ItemClick}})],1)])],1),e._v(" "),a("el-col",{attrs:{span:17}},[a("hgpanel",{staticStyle:{width:"100%"},attrs:{title:e.$t("menu.SpecialReAdm.5ncy6rzdmiw0"),styleCode:e.styleCode,icon:"#nm-icon-paper",panelHeight:e.Height-127}},[a("div",{staticClass:"top-tool-input",attrs:{slot:"tool"},slot:"tool"},[a("el-form",{attrs:{model:e.AdmForm,inline:!0,"label-position":"left"}},["root"!=e.SelectItem.rw?a("el-form-item",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2ygk600"),prop:"Score."+e.SelectItem.index}},[a("el-input",{staticStyle:{width:"80px"},attrs:{disabled:!e.AdmEnable||0!=this.$store.state.login.LoginId&&!e.elementlist.readmaudit,size:"mini"},model:{value:e.AdmForm.Score[e.SelectItem.index],callback:function(t){e.$set(e.AdmForm.Score,e.SelectItem.index,t)},expression:"AdmForm.Score[SelectItem.index]"}})],1):e._e(),e._v(" "),"root"!=e.SelectItem.rw?a("el-form-item",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2yhqqc0"),prop:"Pass."+e.SelectItem.index}},[a("el-select",{staticStyle:{width:"80px"},attrs:{disabled:!e.AdmEnable||0!=this.$store.state.login.LoginId&&!e.elementlist.readmaudit,size:"mini"},on:{change:function(t){return e.AdmFormPassChange(e.SelectItem.index)}},model:{value:e.AdmForm.Pass[e.SelectItem.index],callback:function(t){e.$set(e.AdmForm.Pass,e.SelectItem.index,t)},expression:"AdmForm.Pass[SelectItem.index]"}},[a("el-option",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2yir240"),value:"Y"}}),e._v(" "),a("el-option",{attrs:{label:e.$t("menu.SpecialReAdm.5nrnc2yjr8g0"),value:"N"}})],1)],1):e._e(),e._v(" "),a("el-form-item",[e._e(),e._v(" "),"root"!=e.SelectItem.rw||0!=this.$store.state.login.LoginId&&!e.elementlist.readmaudit?e._e():a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,disabled:!e.AdmEnable},on:{click:function(t){return e.SaveAdm("A")}}},[e._v(e._s(e.$t("menu.SpecialReAdm.5nrnc2yco1c0")))])],1)],1)],1),e._v(" "),a("div",{staticClass:"top-tool-table dialog-table-bottom-radius"},[a("el-table",{staticClass:"dialog-table-bottom-radius",staticStyle:{width:"100%"},attrs:{data:e.AccordTable,"highlight-current-row":"",border:e.styleCode,"header-cell-style":e.headerCellFontWeight,height:e.Height-211}},[a("el-table-column",{attrs:{type:"index",align:"center",width:"40"}}),e._v(" "),e.SelectItem.column&&0!=e.SelectItem.column.length?e._l(e.SelectItem.column,function(e,t){return a("el-table-column",{key:t,attrs:{label:e.split("#")[1],prop:e.split("#")[0],"show-overflow-tooltip":""}})}):a("el-table-column",{attrs:{label:""}})],2)],1)])],1)],1)],1)])])],1)},staticRenderFns:[]};var h=a("VU/8")(d,u,!1,function(e){a("gBQp")},null,null);t.default=h.exports},gBQp:function(e,t){}});