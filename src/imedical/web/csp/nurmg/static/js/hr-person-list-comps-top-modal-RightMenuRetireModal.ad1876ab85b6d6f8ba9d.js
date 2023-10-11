webpackJsonp([171,316],{LNrW:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i("woOf"),a=i.n(n),s={name:"DhcDictCheckBox",data:function(){return{dictList:[],checkedValues:this.value?this.value:[],defaultParam:{ClassName:"web.INMDBComm",MethodName:"FindPubCode",MethodType:"Query",type:""}}},props:{dictCode:{required:!0,type:String},value:{required:!0,type:Array},dictKey:{type:String,default:"SubValue"},dictLabel:{type:String,default:"SubValue"},dictText:{type:String,default:"SubDesc"},checkboxStyle:Object,triggerChange:Boolean},watch:{dictCode:{immediate:!0,handler:function(e){e&&this.loadDictData()}}},created:function(){},methods:{loadDictData:function(){var e=this;a()(this.defaultParam,{type:this.dictCode}),this.asyncRequest(this.defaultParam).then(function(t){e.dictList=t.data.rows}).catch(function(t){e.$message.error("请求复选框字典数据错误")})},changeCheckGroup:function(e){this.triggerChange?this.$emit("change",e):this.$emit("input",e)}}},l={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("el-checkbox-group",{on:{change:e.changeCheckGroup},model:{value:e.checkedValues,callback:function(t){e.checkedValues=t},expression:"checkedValues"}},e._l(e.dictList,function(t){return i("el-checkbox",{key:t[e.dictKey],style:e.checkboxStyle,attrs:{label:t[e.dictLabel]}},[e._v("\n    "+e._s(t[e.dictText])+"\n  ")])}),1)},staticRenderFns:[]},r=i("VU/8")(s,l,!1,null,null,null);t.default=r.exports},yKeH:function(e,t,i){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=i("woOf"),a=i.n(n),s=i("XlQt"),l=i("LNrW"),r=i("QgPK"),o={name:"RightMenuRetireModal",components:{DhcDictCheckBox:l.default,Hgbutton:s.default},mixins:[r.RightMenuMixin],data:function(){return{initData:{RowID:"",ResignCreater:this.LoginId,ResignDate:"",ResignReason:[]},auth:{submit:"resignsubmit"},reasonList:[],rules:{ResignDate:[{required:!0,message:"请选择退休日期",trigger:"change"}],ResignReason:[{type:"array",required:!0,message:"请选择退休原因",trigger:"change"}]},config:{dict:{ClassName:"web.INMDBComm",MethodName:"FindPubCode",MethodType:"Query"},checkRetire:{ClassName:"web.INMInternComm",MethodName:"CheckRetireRec",MethodType:"Method"}}}},created:function(){this.loadDictData()},methods:{loadDictData:function(){var e,t=this;e=a()({},this.config.dict,{type:"退休原因"}),this.asyncRequest(e).then(function(e){t.reasonList=e.data.rows}).catch(function(){t.$message.warning("获取退休原因数据失败")})},handleSubmit:function(){var e=this,t=this.deepClone(this.model),i=this.packageParam(t),n=a()({},this.config.checkRetire,{parr:i});this.$refs.form.validate(function(t){if(!t)return!1;e.asyncRequest(n).then(function(t){t.data>0?(e.nurMessage.success("操作成功"),e.$emit("ok")):0==t.data&&e.nurMessage.warning("操作失败")}).finally(function(){e.close()})})}}},c={render:function(){var e=this,t=e.$createElement,i=e._self._c||t;return i("el-dialog",{attrs:{title:e.$t("menu.RightMenuRetireModal.5nrnbjkd6fw0"),modal:"","close-on-click-modal":!1,top:"15%",visible:e.visible,width:"30%"},on:{"update:visible":function(t){e.visible=t}}},[i("div",{staticClass:"dialog-header-title",attrs:{slot:"title"},slot:"title"},[i("i",{staticClass:"nm-icon-w-paper"}),e._v(" "),i("span",[e._v(e._s(e.$t("menu.RightMenuRetireModal.5nrnbjkd6fw0")))])]),e._v(" "),i("el-form",{ref:"form",attrs:{model:e.model,rules:e.rules,"label-position":"right","label-width":"100px"}},[i("el-form-item",{attrs:{label:e.$t("menu.RightMenuRetireModal.5nrnbjke52o0"),prop:"ResignDate"}},[i("el-date-picker",{staticStyle:{width:"150px"},attrs:{type:"date",format:e.DateFormat,placeholder:e.$t("menu.RightMenuRetireModal.5nrnbjkfnqo0"),size:"mini"},model:{value:e.model.ResignDate,callback:function(t){e.$set(e.model,"ResignDate",t)},expression:"model.ResignDate"}})],1),e._v(" "),i("el-form-item",{attrs:{label:e.$t("menu.RightMenuRetireModal.5nrnbjkglbs0"),prop:"ResignReason"}},[i("el-checkbox-group",{staticStyle:{width:"300px"},model:{value:e.model.ResignReason,callback:function(t){e.$set(e.model,"ResignReason",t)},expression:"model.ResignReason"}},e._l(e.reasonList,function(t){return i("el-checkbox",{key:t.SubValue,staticStyle:{width:"100%",margin:"0",padding:"0"},attrs:{label:t.SubValue}},[e._v(e._s(t.SubDesc)+"\n        ")])}),1)],1)],1),e._v(" "),i("div",{staticStyle:{margin:"10px 0 0 0","font-size":"0","text-align":"center"}},[e.showSubmitAuth?i("hgbutton",{directives:[{name:"intervalclick",rawName:"v-intervalclick",value:{func:e.handleSubmit,time:500},expression:"{func: handleSubmit, time:500}"}],attrs:{type:"default"}},[e._v(e._s(e.$t("menu.RightMenuRetireModal.5nrnbjkgnt80")))]):e._e(),e._v(" "),i("hgbutton",{attrs:{type:"default"},on:{click:e.close}},[e._v(e._s(e.$t("menu.RightMenuRetireModal.5nrnbjkgo8g0")))])],1)],1)},staticRenderFns:[]},u=i("VU/8")(o,c,!1,null,null,null);t.default=u.exports}});