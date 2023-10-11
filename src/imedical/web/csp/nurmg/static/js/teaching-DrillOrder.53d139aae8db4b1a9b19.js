webpackJsonp([235],{"2vdh":function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var l=a("Dd8w"),s=a.n(l),i=a("NYxO"),o=a("XlQt"),n=a("W5Fe"),r={name:"DrillRelease",components:{hgbutton:o.default,hgpagination:n.default},computed:s()({},Object(i.b)(["Height","styleCode"])),data:function(){return{findTypeStore:[{rw:1,desc:"主题"},{rw:2,desc:"方式"},{rw:3,desc:"级别"}],finds:{startDate:new Date,endDate:(new Date).addDate(30),type:"",input:"",CoursesType:["Y","N"]},tableData:[],currentPage:1,pageSize:20,totalCount:0,levelStore:[{rw:"H",desc:"院级"},{rw:"L",desc:"科级"},{rw:"W",desc:"病区"}],DrillWay:[{rw:"O",desc:"在线培训"},{rw:"D",desc:"线下培训"}],DrilTypeStore:[],ExaminerStore:[],dialogVisible:!1,selRow:"",OrderNum:"",tilmList:[]}},methods:{orderClick:function(e){this.selRow=e,this.OrderNum=e.OrderNum,this.dialogVisible=!0},SaveData:function(e){var t=this;if(this.selRow&&this.selRow.subID){var a=this.OrderNum;if("N"==e)a="";else if(this.selRow.TimeList||(a=1),""==a)return void this.$message({type:"warning",message:"请先选择批次",showClose:!0,customClass:"warning_class"});var l=this.selRow.subID+"^"+e+"^"+a,s=this.axiosConfig("web.INMTeaComm","SaveDrillOrder","Method","parr$"+l);this.$ajax.request(s).then(function(e){isNaN(e.data)?e.data.length<100?t.$message({type:"warning",message:e.data,showClose:!0,customClass:"warning_class"}):t.$message({type:"warning",message:"后台方法错了^_^",showClose:!0,customClass:"warning_class"}):(t.$message({message:"保存成功！",type:"success",showClose:!0,customClass:"success_class"}),t.dialogVisible=!1,t.LoadTableData())})}else that.$message({type:"warning",message:"未获取有效数据刷新重试",showClose:!0,customClass:"warning_class"})},GetDescByCode:function(e,t,a,l){var s="";return this[e].forEach(function(e){e[a]==t&&(s=e[l])}),s},LoadExaminerStore:function(){var e=this,t=e.axiosConfig("web.INMTeaComm","FindExaminer","RecQuery","loginID$0");e.$ajax.request(t).then(function(t){e.ExaminerStore=t.data.rows})},HandleCurrentChange:function(e){this.currentPage=e.currentPage,this.LoadTableData()},HandleSizeChange:function(e){this.pageSize=e,this.LoadTableData()},LoadTableData:function(){var e=this,t=e.finds,a=t.startDate,l=t.endDate,s=t.type,i=t.input,o=t.CoursesType;(a=a||"")instanceof Date&&(a=a.Format("YYYY-MM-dd")),(l=l||"")instanceof Date&&(l=l.Format("YYYY-MM-dd")),s=s||"",i=i||"";var n=a+"^"+l+"^"+s+"^"+o.toString()+"^O",r=sessionStorage.getItem("loginID"),c=(e.currentPage-1)*e.pageSize,d=e.pageSize,u=e.axiosConfig("web.INMTeaComm","FindDrillReleaseList","RecQuery","parr$"+n,"input$"+i,"loginID$"+r,"start$"+c,"limit$"+d);e.$ajax.request(u).then(function(t){e.tableData=t.data.rows,e.totalCount=parseInt(t.data.results),e.selRow=""}).catch(function(e){})}},created:function(){this.loadSysParamSubData("护士培训类型","DrilTypeStore"),this.LoadExaminerStore()}},c={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"drill-order-panel",attrs:{id:"DrillRelease"}},[a("div",{staticClass:"top-tool-input"},[a("el-form",{ref:"finds",attrs:{model:e.finds,inline:!0},nativeOn:{submit:function(e){e.preventDefault()}}},[a("el-form-item",{attrs:{label:"开始日期"}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:"开始日期",size:"mini"},model:{value:e.finds.startDate,callback:function(t){e.$set(e.finds,"startDate",t)},expression:"finds.startDate"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"结束日期"}},[a("el-date-picker",{staticStyle:{width:"120px"},attrs:{type:"date",format:this.$store.state.mainframe.DateFormat,placeholder:"开始日期",size:"mini"},model:{value:e.finds.endDate,callback:function(t){e.$set(e.finds,"endDate",t)},expression:"finds.endDate"}})],1),e._v(" "),a("el-form-item",{attrs:{label:"关键字"}},[a("el-select",{staticStyle:{width:"100px"},attrs:{clearable:"",size:"mini",placeholder:"请选择"},model:{value:e.finds.type,callback:function(t){e.$set(e.finds,"type",t)},expression:"finds.type"}},e._l(e.findTypeStore,function(e){return a("el-option",{key:e.rw,attrs:{label:e.desc,value:e.rw}})}),1)],1),e._v(" "),a("el-form-item",[a("el-input",{staticStyle:{width:"140px"},attrs:{clearable:"",size:"mini",placeholder:"请输入关键字"},nativeOn:{keyup:function(t){return!t.type.indexOf("key")&&e._k(t.keyCode,"enter",13,t.key,"Enter")?null:e.LoadTableData(t)}},model:{value:e.finds.input,callback:function(t){e.$set(e.finds,"input",t)},expression:"finds.input"}})],1),e._v(" "),a("el-form-item",[a("el-checkbox-group",{attrs:{size:"mini"},model:{value:e.finds.CoursesType,callback:function(t){e.$set(e.finds,"CoursesType",t)},expression:"finds.CoursesType"}},[a("el-checkbox",{attrs:{label:"Y"}},[e._v("必修")]),e._v(" "),a("el-checkbox",{attrs:{label:"N"}},[e._v("选修")])],1)],1),e._v(" "),a("el-form-item",[a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode,icon:"nm-icon-w-find"},on:{click:e.LoadTableData}},[e._v("查询")])],1)],1)],1),e._v(" "),a("div",{staticClass:"top-tool-table"},[a("el-table",{ref:"menulist",attrs:{data:e.tableData,height:e.Height-90,border:e.styleCode,"header-cell-style":e.headerCellFontWeight,"highlight-current-row":"",align:"left",label:"列表"}},[a("el-table-column",{attrs:{prop:"ReleaseDesc",label:"培训主题","show-overflow-tooltip":""}}),e._v(" "),a("el-table-column",{attrs:{prop:"ReleaseLevel",label:"培训级别",width:"100px","show-overflow-tooltip":"",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n                    "+e._s(e.GetDescByCode("levelStore",t.row.ReleaseLevel,"rw","desc"))+"\n                ")]}}])}),e._v(" "),a("el-table-column",{attrs:{prop:"ReleaseDrillType",label:"培训类型",width:"100px","show-overflow-tooltip":"",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n                    "+e._s(e.GetDescByCode("DrilTypeStore",t.row.ReleaseDrillType,"SubValue","SubDesc"))+"\n                ")]}}])}),e._v(" "),a("el-table-column",{attrs:{prop:"ReleaseWay",label:"培训方式",width:"100px","show-overflow-tooltip":"",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n                    "+e._s(e.GetDescByCode("DrillWay",t.row.ReleaseWay,"rw","desc"))+"\n                ")]}}])}),e._v(" "),a("el-table-column",{attrs:{prop:"DrillCredit",label:"学分",width:"80px","show-overflow-tooltip":"",align:"center"}}),e._v(" "),a("el-table-column",{attrs:{prop:"StartDate",label:"开始日期",width:"120px","show-overflow-tooltip":"",align:"center"}}),e._v(" "),a("el-table-column",{attrs:{prop:"EndDate",label:"结束日期",width:"120px","show-overflow-tooltip":"",align:"center"}}),e._v(" "),a("el-table-column",{attrs:{prop:"Examiner",label:"讲师",width:"90px","show-overflow-tooltip":"",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n                    "+e._s(e.GetDescByCode("ExaminerStore",t.row.Examiner,"rw","desc"))+"\n                ")]}}])}),e._v(" "),a("el-table-column",{attrs:{prop:"DrillCharge",label:"负责人",width:"90px","show-overflow-tooltip":"",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n                    "+e._s(e.GetDescByCode("ExaminerStore",t.row.DrillCharge,"rw","desc"))+"\n                ")]}}])}),e._v(" "),a("el-table-column",{attrs:{prop:"CoursesType",label:"培训分类",width:"100px","show-overflow-tooltip":"",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n                    "+e._s("Y"==t.row.CoursesType?"必修":"选修")+"\n                ")]}}])}),e._v(" "),a("el-table-column",{attrs:{prop:"CreatDate",label:"创建日期",width:"120px","show-overflow-tooltip":"",align:"center"}}),e._v(" "),a("el-table-column",{attrs:{prop:"startStatus",label:"状态",width:"70px","show-overflow-tooltip":"",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[e._v("\n                    "+e._s("N"==t.row.startStatus?"未开始":"已开始")+"\n                ")]}}])}),e._v(" "),a("el-table-column",{attrs:{prop:"OrderFlag",label:"操作",width:"70px",align:"center"},scopedSlots:e._u([{key:"default",fn:function(t){return["O"==t.row.ReleaseWay&&"Y"==t.row.CoursesType?a("font",[e._v("已报名")]):["N"==t.row.startStatus?a("el-button",{staticStyle:{padding:"5px 0px",width:"60px"},attrs:{size:"mini",type:"text"},on:{click:function(a){return e.orderClick(t.row)}}},[e._v("\n                            "+e._s("Y"==t.row.OrderFlag?"修改报名":"报名")+"\n                        ")]):a("font",[e._v("\n                            "+e._s("Y"==t.row.OrderFlag?"已报名":"无法报名")+"\n                        ")])]]}}])})],1),e._v(" "),a("hgpagination",{attrs:{styleCode:e.styleCode,sizes:[20,40,50,100],totalCount:e.totalCount,pageNumber:e.currentPage,pageSize:e.pageSize},on:{changePage:e.HandleCurrentChange,getPageSize:e.HandleSizeChange}})],1),e._v(" "),a("el-dialog",{attrs:{title:"结果查看",visible:e.dialogVisible,"close-on-click-modal":!1,width:"300px"},on:{"update:visible":function(t){e.dialogVisible=t}}},[a("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[e.styleCode?a("i",{staticClass:"nm-icon-paper"}):e._e(),e._v(" "),a("span",[e._v("结果查看")])]),e._v(" "),a("div",{staticStyle:{"padding-left":"10px"}},[a("div",{staticStyle:{"line-height":"28px","font-weight":"600"}},[e._v("培训主题："+e._s(e.selRow.ReleaseDesc))]),e._v(" "),a("div",{staticStyle:{"line-height":"28px","font-weight":"600"}},[e._v("培训级别："+e._s(e.GetDescByCode("levelStore",e.selRow.ReleaseLevel,"rw","desc")))]),e._v(" "),a("div",{staticStyle:{"line-height":"28px","font-weight":"600"}},[e._v("培训类型："+e._s(e.GetDescByCode("DrilTypeStore",e.selRow.ReleaseDrillType,"SubValue","SubDesc")))]),e._v(" "),e.selRow.TimeList?a("el-radio-group",{model:{value:e.OrderNum,callback:function(t){e.OrderNum=t},expression:"OrderNum"}},e._l(e.selRow.TimeList.split("「"),function(t,l){return a("el-radio",{key:l,staticStyle:{"margin-top":"10px"},attrs:{label:l+1+""}},[e._v("\n                    第"+e._s(l+1)+"批次\n                    "),a("div",{staticStyle:{"line-height":"28px","margin-left":"28px"}},[e._v("培训开始时间:"+e._s(t.split("」")[0]))]),e._v(" "),a("div",{staticStyle:{"line-height":"28px","margin-left":"28px"}},[e._v("培训结束时间:"+e._s(t.split("」")[1]))]),e._v(" "),a("div",{staticStyle:{"line-height":"28px","margin-left":"28px"}},[e._v("培训地点:"+e._s(t.split("」")[3]))]),e._v(" "),a("div",{staticStyle:{"line-height":"28px","margin-left":"28px"}},[e._v("预约截至时间:"+e._s(t.split("」")[2]))]),e._v(" "),a("div",{staticStyle:{"line-height":"28px","margin-left":"28px"}},[e._v("预约上线 "+e._s(t.split("」")[4]?t.split("」")[4]:0)+" 人(已预约"+e._s(e.selRow.orderList.split(",")[l])+"人)")])])}),1):e._e()],1),e._v(" "),a("div",{staticClass:"bottom-button"},[a("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.SaveData,time:500,value:"Y"},expression:"{func:SaveData,time:500,value:'Y'}"}],attrs:{type:e.styleCode?"default":"success"}},[e._v("保存")]),e._v(" "),"Y"==e.selRow.OrderFlag?a("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.SaveData,time:500,value:"N"},expression:"{func:SaveData,time:500,value:'N'}"}],attrs:{type:"default",styleCode:e.styleCode}},[e._v("取消报名")]):e._e(),e._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:function(t){e.dialogVisible=!1}}},[e._v("关闭")])],1)])],1)},staticRenderFns:[]};var d=a("VU/8")(r,c,!1,function(e){a("gjcp")},null,null);t.default=d.exports},gjcp:function(e,t){}});