webpackJsonp([10],{R1mg:function(t,e){},s2I2:function(t,e,a){"use strict";Object.defineProperty(e,"__esModule",{value:!0});var i={name:"hgdialog",props:{title:{type:String,default:"提示"},width:{type:String,default:"50%"},top:{type:String,default:"50%"},visible:{type:Boolean,default:!1},modal:{type:Boolean,default:!0},showClose:{type:Boolean,default:!0},icon:{type:String,default:""}},methods:{handlerClose:function(){this.$emit("update:visible",!1)}}},s={render:function(){var t=this,e=t.$createElement,a=t._self._c||e;return a("transition",{attrs:{name:"hg-dialog-fade"}},[a("div",{directives:[{name:"show",rawName:"v-show",value:t.visible,expression:"visible"}],staticClass:"hg-dialog_wrapper",on:{click:function(e){return e.target!==e.currentTarget?null:t.handlerClose(e)}}},[a("div",{staticClass:"hg-dialog",style:{width:t.width,marginTop:t.top}},[a("div",{staticClass:"hg-dialog_header"},[t._t("title",[t.icon?a("span",[t.icon?a("i",{class:[t.icon]}):t._e()]):t._e(),t._v(" "),a("span",{staticClass:"hg-dialog_title"},[t._v("\n                    "+t._s(t.title)+"\n                    ")])]),t._v(" "),a("span",{staticClass:"hg-header-icon",on:{click:t.handlerClose}},[t._v("x")])],2),t._v(" "),a("div",{staticClass:"hg-dialog_body"},[t._t("default")],2),t._v(" "),a("div",{staticClass:"hg-dialog_footer"},[t.$slots.footer?t._t("footer"):t._e()],2)])])])},staticRenderFns:[]};var l=a("VU/8")(i,s,!1,function(t){a("R1mg")},"data-v-7227c8f2",null);e.default=l.exports}});