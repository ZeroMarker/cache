

window.onload = function () {

	var tableconfig = {
		pageTitle:'床位图病区概要配置',
		tableName:'DHC_WARDITEM',
		//actionUrl:'../dhc.nur.sc.testjson.csp',
		tableHead:['ID','代码','名称','显示顺序','可见性','方法','病区代码','分类'],
		rowObject:{ITEM_ROWID:"",ITEM_CODE:"",ITEM_DESC:"",ITEM_ORDER:"",ITEM_VISIBLE:"",ITEM_METHOD:"",ITEM_WARDID:"",ITEM_CATEGORY:''},
		limit:9999,
	};
	var sctable = {
		'template': '<div>'
		 + '<h1>{{pageTitle}}数据维护<h1>'
		+'<div><table class="table sc_cellseparate table-condensed" border-spacing="10px">\
			<tr><td><div class="input-group">\
			<span class="input-group-addon"> 代码 </span><input type="text" class="form-control" placeholder="请输入" v-model="rowObject.ITEM_CODE"></div></td><td>&nbsp;&nbsp;</td>\
			<td><div class="input-group">\
			<span class="input-group-addon ">名称</span><input type="text" class="form-control" placeholder="请输入" v-model="rowObject.ITEM_DESC"></div></td><td>&nbsp;&nbsp;</td>\
			<td><div class="input-group">\
			<span class="input-group-addon">显示顺序</span><input type="text" class="form-control" placeholder="请输入" v-model="rowObject.ITEM_ORDER"></div></td><td>&nbsp;&nbsp;</td>\
			<td><div class="input-group">\
			<span class="input-group-addon">可见性</span>\
			<select class="form-control"  v-model="rowObject.ITEM_VISIBLE">\
			<option value="" >全部</option>\
			<option value="true" >true</option>\
			<option value="false">false</option>\
			</select>\
			</div></td></tr>\
			<tr><td><div class="input-group">\
			<span class="input-group-addon">方法</span><input type="text" class="form-control" placeholder="请输入" v-model="rowObject.ITEM_METHOD"></div></td><td>&nbsp;&nbsp;</td>\
			<td><div class="input-group">\
			<span class="input-group-addon">病区名称</span><input type="text" class="form-control" placeholder="请输入" v-model="searchString" v-on:keydown.enter="searchWardId()"></div></td><td>&nbsp;&nbsp;</td>\
			<td><div class="input-group">\
			<span class="input-group-addon">病区代码</span><input type="text" readonly="readonly" class="form-control" placeholder="" v-model="rowObject.ITEM_WARDID"></div></td><td>&nbsp;&nbsp;</td>\
			<td><div class="input-group">\
			<span class="input-group-addon">分类</span><input type="text" class="form-control" placeholder="请输入" v-model="rowObject.ITEM_CATEGORY"></div></td></tr>\
			<tr><td></td><td></td><td><div  class="sc_overlay" v-show="searchULShow" transition="fade">\
				<ul class="list-group">\
				<template v-for="(ward,index) in evenWardObejcts" >\
				   <a class="list-group-item" v-on:click="selectWard(ward,index)" v-if="index<10">\
				   		<span>{{ward.WARD_Desc}}</span>\
				   		<span style="margin-left:10px">{{ward.WARD_RowID}}</span>\
				   </a>\
				   </template>\
				</ul></div></td>\
			</tr>\
			</table></div>'
			+'<div  class="modal-mask" v-show="modalShow" transition="fade">\
				<div class="modal-wrapper">\
					<div class="modal-container">\
						<div class="modal-header">\
							<slot name="header">\
								确认删除？？\
							</slot>\
						</div>\
						<div class="modal-body">\
							<slot name="body">\
							  <button type="button" class="btn btn-info" v-on:click="confirmModal(1)">确认</button>\
							  &nbsp;&nbsp;&nbsp;&nbsp;\
							  <button type="button" class="btn btn-info"  @click="confirmModal(0)">取消</button>\
							</slot>\
						</div>\
						<!-- <div class="modal-footer">\
							<slot name="footer">\
							  &nbsp;&nbsp;&nbsp;&nbsp;\
							</slot>\
						 </div>-->\
					</div>\
				</div>\
			</div>'
		+'<div align="center">\
			<button type="button" class="btn btn-info" v-on:click="queryByRow(rowObject)">查询</button>\
			&nbsp;&nbsp;\
			<button type="button" class="btn btn-info" v-on:click="addRow(rowObject)">增加</button>\
			&nbsp;&nbsp;\
			<button type="button" class="btn btn-info" v-on:click="updateRow(rowObject)">修改</button>\
			&nbsp;&nbsp;\
			<button type="button" class="btn btn-info" v-on:click="clear(rowObject)">清空</button></div>'
		 + '<table class="table table-hover table-condensed">'
		 + '<thead  align="center"><tr><th v-for="head in tableHead"  align="center">{{head}}</th></thead></tr>'
		 + '<tbody> <tr v-for="(item,index) in rowObjects" :class="{active: activeRow == index}" v-on:click="selected(item,index)"  >'
		 + '<td v-for="(prop,index) in item" >{{prop}}</td> <td><button type="button" class="btn btn-warning" v-on:click="deleteRow(item,index)">删除</button></td>  </tr> </tbody>'
		 + ' </table>'
		 + '<!--<div align="right"><div>共{{totalpages}}页，共{{totalrows}}条'
		 + '<div class="btn-group btn-group-xs">'
		 + '<button type="button" class="btn btn-default" v-on:click="firstPage()">首页</button>'
		 + '<button type="button" class="btn btn-default" v-on:click="previousPage()">上一页</button>'
		 + '<button type="button" class="btn btn-default " disabled="disabled">{{curpage}}</button>'
		 + '<button type="button" class="btn btn-default" v-on:click="nextPage()">下一页</button>'
		 + '<button type="button" class="btn btn-default" v-on:click="lastPage()">尾页</button>'
		 + ''
		 + '</div><input type="text" size="4" placeholder="页码" v-model="jumppagenum"><button type="button" class="btn btn-default  btn-xs" v-on:click="jumpPage()">跳转</button></div>'
		 + '</div>-->'
		 + '</div>',
		data: function () {
			var limit = 10;
			var actionUrl = "./dhc.nur.sc.vueaction.csp";
			if (tableconfig.limit) {
				limit = tableconfig.limit;
			}
			if (tableconfig.actionUrl) {
				actionUrl = actionUrl;
			}
			return {
				tableName: tableconfig.tableName,
				actionUrl: actionUrl,
				tableHead: tableconfig.tableHead,
				rowObject: tableconfig.rowObject,//{}, //
				pageTitle: tableconfig.pageTitle,
				selindex: -3,
				rowObjects: [{}],
				activeRow: -1,
				limit: limit,
				deletingRow:{},
				curpage: 1,
				totalpages: 1,
				totalrows: 1,
				jumppagenum: '',
				confirmDelete:false,
				searchULShow: false,
				modalShow: false,
				wardObejct: {
					WARD_RowID: "",
					WARD_Desc: ""
				},
				wardObejcts: [{}
				],
				searchString: '',
				evenWardObejcts: [{}]
			}
		},
		created: function () {
			var _self = this;
			_self.initRows();
			_self.initWardOpotions();
			//_self.queryByRowObejct();
		},
		watch: {
			searchString: function (searchString) {
				var _self = this;
				_self.evenWardObejcts = [];
				for (var i = 0; i < _self.wardObejcts.length; i++) {
					var temstr = _self.wardObejcts[i].WARD_Desc + "";
					var spell = getPinyin(temstr).toUpperCase();
					if ((temstr.indexOf(searchString) > -1)||(spell.indexOf(searchString.toUpperCase()) > -1)){
						_self.evenWardObejcts.push(_self.wardObejcts[i]);
						//console.log(temstr);
					}

				}
			},
			activeRow: function (activeRow) {
				var _self = this;
				//alert(activeRow);
				if(activeRow>-1){
					var rowObjtmp = _self.rowObjects[activeRow];
					if(rowObjtmp.ITEM_WARDID){
						var wardid = rowObjtmp.ITEM_WARDID;
						for (var i = 0; i < _self.wardObejcts.length; i++) {
							var temstr = _self.wardObejcts[i].WARD_RowID + "";
							if(wardid==temstr){
								_self.searchString=_self.wardObejcts[i].WARD_Desc;
							}
						}
					}
				}
			},
			'rowObject.ITEM_ORDER':function(){
				//alert("1");
				var _self = this;
				var order = _self.rowObject.ITEM_ORDER;
				if(order!=""&&isNaN(order)){
					alert("请输入数字!");
					_self.rowObject.ITEM_ORDER="";
					return ;
				}
				else if(order!=""&&parseInt(order)!=order){
					alert("请输入整数!");
					_self.rowObject.ITEM_ORDER="";
					return ;
				}
				else{
					return;
				}
            }
		},
		computed: {
			
		},
		methods: {
			change: function () {
				this.ok = !this.ok;
			},
			selected: function (sctyp, index) {
				var _self = this;
				if(_self.selindex == index){
					for (var prop in sctyp) {
						_self.rowObject[prop] = "";						
					}
					//alert("1");
					_self.selindex = -2;
					_self.activeRow = -1;
					_self.searchString="";
				}else{
					for (var prop in sctyp) {
						_self.rowObject[prop] = sctyp[prop];
					}
					//_self.rowObject = sctyp
					_self.activeRow = index;
					_self.selindex = index;
				}
				//_self.rowObject = sctyp
				//for (var prop in sctyp) {
				//	_self.rowObject[prop] = sctyp[prop];
				//}
				//console.log(_self.rowObject);
				

			},
			clear: function(sctyp){
				var _self =this;
				var rowObjectNull={ITEM_ROWID:"",ITEM_CODE:"",ITEM_DESC:"",ITEM_ORDER:"",ITEM_VISIBLE:"",ITEM_METHOD:"",ITEM_WARDID:"",ITEM_CATEGORY:''};
				_self.rowObject = rowObjectNull;
				//alert("1");
				_self.selindex = -2;
				_self.activeRow = -1;
				_self.searchString="";
			},
			initRows: function () {
				var _self = this;
				var limit = _self.limit;
				var curpage = _self.curpage;
				var postUrl = _self.actionUrl + '?actionmethod=scvue_query&&tablename=' + _self.tableName;
				$.post(postUrl, {
					page: curpage,
					limit: limit
				}, function (data) {
					//console.log(data);
					var jsonObjs = eval("(" + data + ")");
					//console.log(jsonObjs);
					_self.rowObjects = jsonObjs.rows;
					//_self.rowObject = newRowObj(_self.rowObjects[0]);
					_self.totalrows = jsonObjs.total;
					_self.totalpages = Math.ceil(_self.totalrows / _self.limit);
				});
			},
			initWardOpotions: function () {
				var _self = this;
				_self.queryByRowObejct("PAC_Ward", _self.wardObejct);

			},
			addRow: function (sctyp) {
				//console.log(sctyp)
				var str = isPropertyNull(sctyp);
				if(str!="0"){
					alert(str);
					return ;
				}
				var param = packageParam(sctyp);
				//console.log(param);
				var _self = this;
				var postUrl = _self.actionUrl + '?actionmethod=scvue_add&&tablename=' + _self.tableName;
				$.post(postUrl, param, function (data) {
					if (data.replace(/(^\s*)|(\s*$)/, "") == "1") {
						_self.queryRows();
						//sctyp.ITEM_ROWID=""
						//_self.rowObjects.push(sctyp);
						/* if(_self.totalrows>0){
							var isAddPage = (_self.totalrows + 1) % _self.limit
							if (isAddPage == 1) {
								_self.curpage = _self.curpage + 1;
								_self.queryRows();
							} else {
								_self.lastPage();
							}
						}
						else {
							
								_self.queryRows();
						} */
					}
				});
				//alert(_self.totalpages);
			},
			deleteRow: function (sctyp, index) {
				var _self = this; //console.log(_self.rowObjects);
				_self.modalShow=true;
				_self.deletingRow =sctyp;
				
			},
			confirmModal:function(flag){
				var _self = this;
				if(flag==1){
					_self.deletePost();
					_self.modalShow = false;
				}
				if(flag==0){
					_self.modalShow = false;
					_self.deletingRow={};
				}
					
			},
			deletePost:function(){
				var _self = this; //console.log(_self.rowObjects);
				var sctyp = _self.deletingRow;
				var param = packageParam(sctyp);
				var postUrl = _self.actionUrl + '?actionmethod=scvue_delete&&tablename=' + _self.tableName;
				$.post(postUrl, param, function (data) {
					if (data.replace(/(^\s*)|(\s*$)/, "") == "1") {
						//console.log(param);
						//_self.rowObjects.splice(index, 1);
						_self.queryRows();
					}
				});				
			},
			queryRows: function () {
				var _self = this;
				var limit = _self.limit;
				var curpage = _self.curpage;
				var postUrl = _self.actionUrl + '?actionmethod=scvue_query&&tablename=' + _self.tableName;
				$.post(postUrl, {
					page: curpage,
					limit: limit
				}, function (data) {
					var jsonObjs = eval("(" + data + ")");
					_self.rowObjects = jsonObjs.rows;
					//_self.rowObject = newRowObj(_self.rowObjects[0]);
					_self.totalrows = jsonObjs.total;
					_self.totalpages = Math.ceil(_self.totalrows / _self.limit);
				});
			},
			queryByRowObejct: function ( tableName,varobject) {
				var _self = this;
				var limit = _self.limit;
				var curpage = _self.curpage;
				var param = packageJsonStrParam(varobject);
				//console.log(param);
				var postUrl = _self.actionUrl + '?actionmethod=scvue_queryrow&&tablename=' + tableName;
				$.post(postUrl, {
					page: curpage,
					limit: limit,
					param: param
				}, function (data) {
					var jsonObjs = eval("(" + data + ")");
					_self.wardObejcts = jsonObjs.rows;
					var wardqy = {WARD_RowID:"all",WARD_Desc:"全院"};
					_self.wardObejcts.push(wardqy);
					//_self.rowObject = newRowObj(_self.rowObjects[0]);
					//_self.totalrows = jsonObjs.total;
					//_self.totalpages = Math.ceil(_self.totalrows/_self.limit);
				});
			},
			queryByRow: function ( varobject) {
				var _self = this;
				var limit = _self.limit;
				var curpage = _self.curpage;
				var param = packageJsonStrParam(varobject);
				//console.log(param);
				var postUrl = _self.actionUrl + '?actionmethod=scvue_queryrow&&tablename=' + _self.tableName;
				$.post(postUrl, {
					page: curpage,
					limit: limit,
					param: param
				}, function (data) {
					var jsonObjs = eval("(" + data + ")");
					//console.log(jsonObjs);
					_self.rowObjects = jsonObjs.rows;
					//_self.rowObject = newRowObj(_self.rowObjects[0]);
					_self.totalrows = jsonObjs.total;
					_self.totalpages = Math.ceil(_self.totalrows / _self.limit);
					//_self.rowObject = newRowObj(_self.rowObjects[0]);
					//_self.totalrows = jsonObjs.total;
					//_self.totalpages = Math.ceil(_self.totalrows/_self.limit);
				});
			},
			updateRow: function (sctyp) {
				//var param = objToJSON(sctyp);
				var param = packageParam(sctyp);
				var _self = this;
				//console.log(_self.activeRow);
				var visibilFlag = sctyp.ITEM_VISIBLE;
				if(visibilFlag==""){
					alert("请选择可见性！");
					return;
				}
				var rowid = sctyp.TYP_ROWID;
				var postUrl = _self.actionUrl + '?actionmethod=scvue_update&&tablename=' + _self.tableName;
				$.post(postUrl, param, function (data) {
					if (data.replace(/(^\s*)|(\s*$)/, "") == "1") {
						for (var prop in sctyp) {
						_self.rowObjects[_self.activeRow][prop] = sctyp[prop];
						}
						//_self.rowObjects[_self.activeRow] =  sctyp;
						//_self.queryRows();
					}
				});
			},
			firstPage: function () {
				var _self = this;
				_self.curpage = 1;
				_self.queryRows();
			},
			previousPage: function () {
				var _self = this;
				if (_self.curpage > 1) {
					_self.curpage = _self.curpage - 1;
					_self.queryRows();
				}
			},
			nextPage: function () {
				var _self = this;
				if (_self.curpage < _self.totalpages) {
					_self.curpage = _self.curpage + 1;
					_self.queryRows();
				}
			},
			lastPage: function () {
				var _self = this;
				_self.curpage = _self.totalpages;
				_self.queryRows();
			},
			jumpPage: function () {
				var _self = this;
				if(_self.jumppagenum<_self.totalpages+1){
					_self.curpage = _self.jumppagenum;
					_self.queryRows();
				}else{
					alert("要跳转到页面大于总页数，请修改！");
				}
			},
			searchWardId: function () {
				var _self = this;
				_self.searchULShow = !_self.searchULShow;
				//console.log("唉");
				$('#myModal').modal('show');
			},
			selectWard: function (ward, index) {
				var _self = this;
				_self.searchString = ward.WARD_Desc;
				_self.rowObject.ITEM_WARDID = ward.WARD_RowID;
				_self.searchULShow = !_self.searchULShow;
				//console.log(ward);
			}
		}
	}
	var demo = new Vue({
			el: '#main',
			components:{
				//counter1:counter1,
				sctable:sctable
			}
		});
	
} 

/**
 *创建行对象
 */
function newRowObj(obj) {
	console.log(obj);
	var rowObj = new Object();

	for (var prop in obj) {
		rowObj[prop] = "";
	}
	//rowObj = obj;
	return rowObj;
}

/**
 *对象转换成json,用于后台提交
 */
function objToJSON(obj) {
	//console.log(obj)
	var jsonObjs = [{}
	];
	//json.push(obj);
	var jsonStr = '';
	for (var prop in obj) {
		jsonStr = jsonStr + prop + ':"' + obj[prop] + '",';
	}
	jsonStr = '{' + jsonStr + '}';
	jsonObjs = eval("(" + jsonStr + ")");
	return jsonObjs;
}
/**
 *对象转换成"1:a^2:B^3^4^#%#",用于后台提交
 */
function packageJsonStrParam(obj) {
	//console.log(obj)
	var jsonObjs = [{}
	];
	//json.push(obj);
	var jsonStr = '';
	for (var prop in obj) {
		jsonStr = jsonStr + prop + ":" + obj[prop]+ '^';
	}
	//jsonStr = '{param:"' + jsonStr + '#%#"}';
	//console.log(jsonStr)
	//jsonObjs = eval("(" + jsonStr + ")");
	return jsonStr;
}
/**
 *对象转换成"1^2^3^4^#%#",用于后台提交
 */
function packageParam(obj) {
	//console.log(obj)
	var jsonObjs = [{}
	];
	//json.push(obj);
	var jsonStr = '';
	for (var prop in obj) {
		jsonStr = jsonStr + prop + ":" + obj[prop].replace(/\"/g, "\\\"") + '^';
	}
	jsonStr = '{param:"' + jsonStr + '#%#"}';
	//console.log(jsonStr)
	jsonObjs = eval("(" + jsonStr + ")");
	return jsonObjs;
}
/**
 *对象转换成"1^2^3^4^#%#",用于后台提交
 */
function packageParamStr(obj) {
	//console.log(obj)
	var jsonObjs = [{}
	];
	//json.push(obj);
	var jsonStr = '';
	for (var prop in obj) {
		jsonStr = jsonStr + prop + '^';
	}
	//jsonStr=jsonStr;
	//console.log(jsonStr)
	//jsonObjs = eval("("+jsonStr+")");
	return jsonStr;
}

/**
 *对象属性是否为空
 */
function isPropertyNull(obj) {
	if(obj.ITEM_CODE==""){
		return "请输入代码！"
	}
	else if(obj.ITEM_DESC==""){
		return "请输入名称！"
	}
	else if(obj.ITEM_ORDER==""){
		return "请输入显示顺序！"
	}
	else if(obj.ITEM_VISIBLE==""){
		return "请输入可见性！"
	}
	else if(obj.ITEM_METHOD==""){
		return "请输入方法！"
	}
	else if(obj.ITEM_WARDID==""){
		return "请输入病区代码！"
	}
	else{
		return 0;
	}
}
