(window.webpackJsonp=window.webpackJsonp||[]).push([["chunk-5d416c94"],{"59f9":function(t,e,n){"use strict";n("6114")},6114:function(t,e,n){},"94ab":function(t,e,n){"use strict";n.r(e);n("a4d3"),n("e01a"),n("d3b7"),n("d28b"),n("3ca3"),n("ddb0"),n("fb6a"),n("b0c0"),n("a630"),n("ac1f"),n("00b4");function i(t,e){(null==e||e>t.length)&&(e=t.length);for(var n=0,i=new Array(e);n<e;n++)i[n]=t[n];return i}function r(t,e){var n="undefined"!=typeof Symbol&&t[Symbol.iterator]||t["@@iterator"];if(!n){if(Array.isArray(t)||(n=function(t,e){if(t){if("string"==typeof t)return i(t,e);var n=Object.prototype.toString.call(t).slice(8,-1);return"Object"===n&&t.constructor&&(n=t.constructor.name),"Map"===n||"Set"===n?Array.from(t):"Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)?i(t,e):void 0}}(t))||e&&t&&"number"==typeof t.length){n&&(t=n);var r=0,o=function(){};return{s:o,n:function(){return r>=t.length?{done:!0}:{done:!1,value:t[r++]}},e:function(t){throw t},f:o}}throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}var s,a=!0,l=!1;return{s:function(){n=n.call(t)},n:function(){var t=n.next();return a=t.done,t},e:function(t){l=!0,s=t},f:function(){try{a||null==n.return||n.return()}finally{if(l)throw s}}}}n("4e82"),n("a434"),n("159b");var o={data:function(){return{stringMark:" ",textArr:[],selected:[],items:[],movable:{dom:null,top:0,left:0,width:0,height:0},point:{start:{x:0,y:0},end:{x:0,y:0},moving:!1}}},methods:{showSelecte:function(){var t="";this.selected.sort((function(t,e){return t-e}));for(var e=0;e<this.selected.length;e++)t+=this.textArr[this.selected[e]];parent.WriteToEmr(t)},push:function(t,e){this.items[e]={selected:!1,dom:t}},down:function(t){this.point.start.x=t.x,this.point.start.y=t.y,this.movable.left=t.x+"px",this.movable.top=t.y+"px",this.point.moving=!0},move:function(t){if(this.point.moving){var e=t.x,n=t.y;this.movable.height=Math.abs(this.point.start.y-n)+"px",this.movable.width=Math.abs(this.point.start.x-e)+"px"}},up:function(t){if(this.point.moving){this.movable.width=0,this.movable.height=0,this.point.end.x=t.x,this.point.end.y=t.y,this.point.moving=!1;for(var e=0;e<this.items.length;e++)this.isSelected(this.items[e].dom.getBoundingClientRect())&&(this.selected.indexOf(e)<0?this.selected.push(e):this.selected.splice(this.selected.indexOf(e),1))}},getPosition:function(){var t=[];return t.push(this.point.start),t.push(this.point.end),t.push({x:this.point.end.x,y:this.point.start.y}),t.push({x:this.point.start.x,y:this.point.end.y}),t},isSelected:function(t){void 0===t.x&&(t.x=t.left),void 0===t.y&&(t.y=t.top);for(var e=this.getPosition(),n=[{x:t.x,y:t.y},{x:t.x+t.width,y:t.y+t.height},{x:t.x+t.width,y:t.y},{x:t.x,y:t.y+t.height}],i=0,o=n;i<o.length;i++){var s=o[i];if(s.x>e[0].x&&s.x<e[1].x&&s.y>e[0].y&&s.y<e[1].y)return!0}var a,l=r(e);try{for(l.s();!(a=l.n()).done;){var c=a.value;if(c.x>n[0].x&&c.x<n[1].x&&c.y>n[0].y&&c.y<n[1].y)return!0}}catch(t){l.e(t)}finally{l.f()}return e[0].x<n[0].x&&e[1].x>n[1].x&&e[0].y>n[0].y&&e[1].y<n[1].y||e[0].x>n[0].x&&e[1].x<n[1].x&&e[0].y<n[0].y&&e[1].y>n[1].y},goBack:function(){this.$router.go(-1)},WriteToEmr:function(){if(!this.selected.length>1);else{var t="",e=this;this.selected.forEach((function(n,i){t=i>0?t+e.stringMark+e.items[n].dom.textContent:e.items[n].dom.textContent})),parent.WriteToEmr(t)}}},created:function(){this.textArr=JSON.parse(decodeURIComponent(this.$route.params.text))},mounted:function(){var t=this;this.$refs.Unitword.forEach((function(e,n){t.items[n]={selected:!1,dom:e}}))}},s=(n("59f9"),n("2877")),a=Object(s.a)(o,(function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",{staticStyle:{"overflow-y":"scroll",height:"100%"}},[n("div",{staticClass:"SuspectedContainer"},[n("div",{staticClass:"CaptionRect titleName"},[t._v("文本选择")]),n("div",{staticClass:"test",on:{mousedown:function(e){return e.preventDefault(),t.down.apply(null,arguments)},mousemove:function(e){return e.preventDefault(),t.move.apply(null,arguments)},mouseup:function(e){return e.preventDefault(),t.up.apply(null,arguments)}}},[n("div",{staticClass:"move"}),t._l(t.textArr,(function(e,i){return n("span",{key:i,ref:"Unitword",refInFor:!0,staticClass:"item",class:{selected:t.selected.indexOf(i)>-1}},[t._v(" "+t._s(e)+" ")])}))],2)]),n("div",{staticClass:"SuspectedContainer"},[n("div",{staticClass:"CaptionRect titleName"},[t._v("符号选择")]),n("div",{staticStyle:{"text-align":"center"}},[n("el-radio",{attrs:{label:" "},model:{value:t.stringMark,callback:function(e){t.stringMark=e},expression:"stringMark"}}),n("el-radio",{attrs:{label:"，"},model:{value:t.stringMark,callback:function(e){t.stringMark=e},expression:"stringMark"}},[t._v("，")]),n("el-radio",{attrs:{label:"、"},model:{value:t.stringMark,callback:function(e){t.stringMark=e},expression:"stringMark"}},[t._v("、")]),n("el-radio",{attrs:{label:"。"},model:{value:t.stringMark,callback:function(e){t.stringMark=e},expression:"stringMark"}},[t._v("。")])],1)]),n("div",{staticStyle:{display:"flex"}},[n("button",{attrs:{id:"commit"},on:{click:function(e){return t.WriteToEmr()}}},[t._v("写回")]),n("button",{attrs:{id:"commit"},on:{click:function(e){return t.goBack()}}},[t._v("返回")])])])}),[],!1,null,"0aae6794",null);e.default=a.exports}}]);