webpackJsonp([243],{GRmT:function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var s=a("Dd8w"),o=a.n(s),r=a("NYxO"),n={name:"ExamOperaton",props:["releaseId","userId","examDesc","operaDesc","operaId","WardDR","WardDesc"],components:{hgbutton:a("XlQt").default},computed:o()({},Object(r.b)(["styleCode"])),data:function(){return{TdStyle:{},TableData:[],OperaMode:"",Deepth:1,contextMenuData:{menuName:"taskmenulist",axis:{x:null,y:null},menulists:[],checkedValueList:[]},selectrow:{},CheckInfo:{CreateUser:"",CreateUserDesc:"",CheckWard:"",CheckWardDesc:"",CheckDate:new Date,CheckScore:"0",CheckStatus:"未提交",Remark:"",rw:""},totalScore:0,Editable:!1}},methods:{GetFatherShow:function(e){var t=this;return!e.some(function(e){return 1!=t.TableData.find(function(t){return t.SubSort==e}).FatherShow})},GetFatherRowSpan:function(e){return e=e.substring(0,e.lastIndexOf(".")),this.TableData.find(function(t){return t.SubSort==e}).RowSpan},GetFatherDesc:function(e){return e=e.substring(0,e.lastIndexOf(".")),this.TableData.find(function(t){return t.SubSort==e}).SubItem},GetSchduleData:function(){var e=this;e.$ajax.request(e.axiosConfig("web.INMTeaComm","GetOperationCheck","Method","releaseId$"+e.releaseId,"operaId$"+e.operaId,"UserID$"+e.userId)).then(function(t){if(t.data instanceof Object){var a=0;e.OperaMode=t.data.OperaMode,e.CheckInfo.CheckStatus=t.data.CheckStatus,e.CheckInfo.rw=t.data.ExamId,e.CheckInfo.Remark=t.data.Remark,e.CheckInfo.rw?e.Editable=!1:e.Editable=!0,e.Deepth=isNaN(parseInt(t.data.Deepth))?1:parseInt(t.data.Deepth),t.data.SubItems.forEach(function(e){if(0==e.HasChild){if("B"==t.data.OperaMode){e.ItemScore||(e.ItemScore="」」");var s=e.ItemScore;e.ScoreToShow="";var o=e.CheckMenu.split("「");if(s)if("-"==s)e.ScoreToShow="不适用";else{var r="";s.split("」").forEach(function(e,t){e&&(r=r?r+","+o[t].split("」")[0]+":"+e:o[t].split("」")[0]+":"+e)}),e.ScoreToShow=r}else e.ScoreToShow=""}else if("F"==t.data.OperaMode){var n=e.CheckMenu.split("「"),c=e.ItemScore;if(c){var i="";c.split("」").forEach(function(e,t){e&&(i=i?i+","+n[t].split("」")[0]:n[t].split("」")[0])}),e.ScoreToShow=i}else e.ScoreToShow=""}if("A"!=t.data.OperaMode&&"B"!=t.data.OperaMode&&0==e.HasChild){var l=Number(e.SubScore);a+=isNaN(l)?0:l}}}),e.totalScore=a,e.TableData=t.data.SubItems,e.CalculateTotal()}else e.$message({type:"error",message:"获取检查单失败!",showClose:!0,customClass:"error_class"})}).catch(function(t){e.$message({type:"error",message:"获取检查单失败!",showClose:!0,customClass:"error_class"})})},CellClickEvent:function(e,t,a,s){if(this.Editable){var o=[];t.CheckMenu&&t.CheckMenu.split("「").forEach(function(e,r){var n=e.split("」"),c=n[0],i=n[1],l=n[2]?n[2]:"",h=!(!a||"不适用"==c),u=!(!s||"不适用"==c),d=r+"",m="";h&&t.ItemScore&&"-"!=t.ItemScore&&(m=t.ItemScore.split("」")[r]),o.push({fnHandler:h?"":"MarkScore",icoName:l,btnName:c,fnHandlerArg:i,showInput:h,inputValue:m,showCheckBox:u,checkedValue:d})}),this.selectrow=t,s&&(t.ItemScore?t.ItemScore instanceof Array?this.contextMenuData.checkedValueList=t.ItemScore:this.contextMenuData.checkedValueList=t.ItemScore.split("」"):this.contextMenuData.checkedValueList.splice(0,this.contextMenuData.checkedValueList.length)),this.contextMenuData.menulists=o,this.contextMenuData.axis={x:e.clientX,y:e.clientY}}},ChangeScore:function(e){if(this.Editable){this.selectrow=e;var t=Number(e.ItemScore),a=this.OperaMode;if(isNaN(t));else if(t>Number(e.SubScore)){var s=Number(e.SubScore);e.ItemScore="C"==a?s:-s}else"C"==a&&t<0?e.ItemScore=0:"D"==a&&(Math.abs(t)>Number(e.SubScore)?e.ItemScore=-Number(e.SubScore):e.ItemScore=-Math.abs(t));this.CalculateTotal()}},MarkScore:function(e){this.selectrow.ItemScore=e,"-"==e&&"B"==this.OperaMode&&(this.selectrow.ScoreToShow="不适用"),this.CalculateTotal()},HandleCountChange:function(e,t){"-"==this.selectrow.ItemScore&&this.selectrow.ItemScore;var a=this.selectrow.ItemScore.split("」");a[t]=e,this.selectrow.ItemScore=a.join("」");var s=this.selectrow.CheckMenu.split("「"),o="";a.forEach(function(e,t){e&&(o=o?o+","+s[t].split("」")[0]+":"+e:s[t].split("」")[0]+":"+e)}),this.selectrow.ScoreToShow=o,this.CalculateTotal()},HandleCheckChange:function(e,t,a){this.selectrow.ItemScore=e;var s=this.selectrow.CheckMenu.split("「"),o="";e.forEach(function(e){o=o?o+","+s[parseInt(e)].split("」")[0]:s[parseInt(e)].split("」")[0]}),this.selectrow.ScoreToShow=o,this.CalculateTotal()},CalculateTotal:function(){var e=0,t=0,a=0,s=0,o=0,r=0,n=this.OperaMode;if(this.TableData.forEach(function(c){if(0==c.HasChild)if("A"==n)"√"==c.ItemScore?a+=1:"×"==c.ItemScore&&(t+=1);else if("B"==n){if("-"!=c.ItemScore){var i=c.ItemScore.split("」");s+=i[0]?isNaN(parseInt(i[0]))?0:parseInt(i[0]):0,o+=i[0]?isNaN(parseInt(i[1]))?0:parseInt(i[1]):0,r+=i[0]?isNaN(parseInt(i[2]))?0:parseInt(i[2]):0}}else if("C"==n||"D"==n||"E"==n){var l=Number(c.ItemScore);e+=isNaN(l)?0:l}else if("F"==n){var h=c.ItemScore;h?c.ItemScore instanceof Array||(h=h.split("」")):h=new Array;var u=c.CheckMenu.split("「"),d=0;h.forEach(function(e){if(e=parseInt(e),!(isNaN(e)||e>=u.length)){var t=u[e].split("」")[1];t=Number(t),isNaN(t)||(d-=t)}}),Math.abs(d)>Number(c.SubScore)&&(d=-Number(c.SubScore)),e+=d}}),"A"==n){var c="100%";a+t!=0&&(c=(a/(a+t)*100).toFixed(2)+"%"),this.CheckInfo.CheckScore=c}else if("B"==n){var i="100%";s+o+r!=0&&(i=(s/(s+o+r)*100).toFixed(2)+"%"),this.CheckInfo.CheckScore=i}else"C"==n||"E"==n?this.CheckInfo.CheckScore=e:"D"!=n&&"F"!=n||(this.CheckInfo.CheckScore=this.totalScore+e)},Save:function(e){var t=this,a=this.userId+"^"+this.releaseId+"^"+this.operaId+"^"+this.WardDR+"^"+this.CheckInfo.CheckDate.Format("YYYY-MM-dd");a=a+"^"+this.CheckInfo.CheckScore+"^"+e+"^"+this.CheckInfo.Remark+"^"+this.CheckInfo.rw;var s="";this.TableData.forEach(function(e){var t="";e.ItemScore instanceof Array?e.ItemScore.forEach(function(e,a){t=0==a?e:t+"」"+e}):t=e.ItemScore,s=s?s+"ˇ"+e.SubId+"^"+t+"^"+e.ResultSubId+"^"+e.Remark:e.SubId+"^"+t+"^"+e.ResultSubId+"^"+e.Remark});var o=this.axiosConfig("web.INMTeaComm","SaveOperationCheck","Method","parr$"+a,"table$"+s,"loginID$"+sessionStorage.getItem("loginID"));this.$ajax.request(o).then(function(e){!isNaN(Number(e.data))&&Number(e.data)>0?(t.$emit("CloseClick"),t.$message({type:"success",message:"保存成功",showClose:!0,customClass:"success_class"})):e.data.length<100?t.$message({type:"error",message:e.data,showClose:!0,customClass:"error_class"}):that.$message({type:"warning",message:"后台方法错了^_^",showClose:!0,customClass:"warning_class"})}).catch(function(e){t.$message({type:"error",message:"保存失败",showClose:!0,customClass:"error_class"})})},CloseClick:function(){this.$emit("CloseClick")}},created:function(){this.CheckInfo.CheckWardDesc=this.WardDesc,this.CheckInfo.CreateUserDesc=sessionStorage.getItem("loginName"),this.CheckInfo.CreateUser=sessionStorage.getItem("loginID"),this.GetSchduleData()}},c={render:function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"exam-operation-print",attrs:{id:"schduleprint"}},[a("div",{staticStyle:{"font-size":"18px","font-weight":"bold","text-align":"center","margin-bottom":"10px",color:"#000"}},[e._v(e._s(e.operaDesc))]),e._v(" "),a("div",{staticClass:"printCheckInfo"},[a("span",{staticStyle:{display:"inline-block",color:"red"}},[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94bwi80")))]),a("span",[e._v(e._s(e.CheckInfo.CreateUserDesc))]),e._v(" "),a("span",[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94cia80")))]),a("span",[e._v(e._s(e.CheckInfo.CheckWardDesc))]),e._v(" "),a("span",[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94czno0")))]),a("span",[e._v(e._s(e.CheckInfo.CheckDate instanceof Date?e.CheckInfo.CheckDate.Format("YYYY-MM-dd"):""))]),e._v(" "),a("span",[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94dkx80")))]),a("span",[e._v(e._s(e.CheckInfo.CheckScore))])]),e._v(" "),a("table",{attrs:{cellspacing:"0",cellpadding:"0",border:"0"}},[a("thead",[a("tr",[a("th",{attrs:{colspan:e.Deepth}},[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94ewsw0")))]),e._v(" "),"A"!=e.OperaMode&&"B"!=e.OperaMode?a("th",[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94extg0")))]):e._e(),e._v(" "),a("th",[e._v(e._s("得分"))]),e._v(" "),a("th",[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94fx0c0")))])])]),e._v(" "),a("tbody",[e._l(e.TableData,function(t,s){return[0==t.HasChild?a("tr",{key:"item"+s},[e._l(t.Roots,function(s,o){return[1==t.FatherShow&&e.GetFatherShow(t.Roots.slice(o,-1))?a("td",{key:o,attrs:{rowspan:e.GetFatherRowSpan(s)}},[e._v("\n                            "+e._s(e.GetFatherDesc(s))+"\n                        ")]):e._e()]}),e._v(" "),a("td",{attrs:{colspan:e.Deepth-t.SubSort.split(".").length+1}},[e._v(e._s(t.SubItem))]),e._v(" "),"A"!=e.OperaMode&&"B"!=e.OperaMode?a("td",{attrs:{align:"left"}},[e._v(e._s(t.SubScore))]):e._e(),e._v(" "),a("td",{staticStyle:{position:"relative",width:"120px",overflow:"hidden",padding:"1px 1px"},attrs:{align:"left"}},["C"==e.OperaMode||"D"==e.OperaMode?a("el-input",{staticStyle:{"text-align":"left",border:"none"},attrs:{readonly:!e.Editable},on:{blur:function(a){return e.ChangeScore(t)}},model:{value:t.ItemScore,callback:function(a){e.$set(t,"ItemScore",a)},expression:"item['ItemScore']"}}):"E"==e.OperaMode?a("div",{on:{click:function(a){return e.CellClickEvent(a,t,!1,!1)}}},[a("span",{staticStyle:{position:"absolute",top:"50%",transform:"translateY(-50%)"}},[e._v(e._s(t.ItemScore))])]):"F"==e.OperaMode?a("div",{on:{click:function(a){return e.CellClickEvent(a,t,!1,!0)}}},[a("span",[e._v(e._s(t.ScoreToShow))])]):"A"==e.OperaMode?a("div",{on:{click:function(a){return e.CellClickEvent(a,t,!1,!1)}}},[a("span",{staticStyle:{position:"absolute",top:"50%",transform:"translateY(-50%)"}},[e._v(e._s(t.ItemScore))])]):"B"==e.OperaMode?a("div",{on:{click:function(a){return e.CellClickEvent(a,t,!0,!1)}}},[a("span",[e._v(e._s(t.ScoreToShow))])]):e._e()],1),e._v(" "),a("td",{staticStyle:{width:"200px",padding:"1px 1px"},attrs:{align:"center"}},[a("el-input",{staticStyle:{border:"none",width:"100%"},attrs:{readonly:!e.Editable},model:{value:t.Remark,callback:function(a){e.$set(t,"Remark",a)},expression:"item['Remark']"}})],1)],2):e._e()]})],2)]),e._v(" "),a("div",{staticStyle:{"margin-top":"10px"}},[a("el-input",{attrs:{disabled:!e.Editable,type:"textarea",size:"small",maxlength:1e3,"show-word-limit":"",rows:3},model:{value:e.CheckInfo.Remark,callback:function(t){e.$set(e.CheckInfo,"Remark",t)},expression:"CheckInfo.Remark"}})],1),e._v(" "),a("div",{staticClass:"bottom-button"},[e.Editable?a("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.Save,time:500,value:"S"},expression:"{func:Save,time:500,value:'S'}"}],attrs:{type:"default",styleCode:e.styleCode}},[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94g4b40")))]):e._e(),e._v(" "),a("hgbutton",{attrs:{type:"default",styleCode:e.styleCode},on:{click:e.CloseClick}},[e._v(e._s(e.$t("menu.ExamOperation.5nrnc94g4p00")))])],1),e._v(" "),a("vue-context-menu",{ref:"cellContextMenu",attrs:{contextMenuData:e.contextMenuData},on:{MarkScore:e.MarkScore,change:e.HandleCountChange,checkChange:e.HandleCheckChange}})],1)},staticRenderFns:[]};var i=a("VU/8")(n,c,!1,function(e){a("lIaL")},null,null);t.default=i.exports},lIaL:function(e,t){}});