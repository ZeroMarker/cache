Vue.component('im-panel',{
	template:'<div class="panel panel-primary im-panel">\
				<div class="panel-heading" @click="panelHeaderClick();">\
					<span class="glyphicon" :class="{\'glyphicon-plus\':c,\'glyphicon-minus\':!c}" aria-hidden="true"></span>{{title}}\
				</div>\
				<div  class="panel-body" :style="bodyDisplay">\
					<slot name="body"></slot>\
				</div>\
				<div :style="bodyDisplay">\
				<slot></slot>\
				</div>\
			</div>',
	props:{
		height:{
			type:Number,
			'default':300,
			required:false,
			validator:function(value){
				return value>0 ;
			}
		},
		collapsed:{
			type:Boolean,
			'default':false
		},
		title:{
			'default':""
		}
	},
	data:function(){
		return {"c":false};
	},
	computed:{
		bodyDisplay:function(){
			return {
				display:this.c?'none':'block'
			};
		}
	},
	created:function(){
		this.c=this.collapsed;
	},
	methods:{
		panelHeaderClick:function(){
			this.c = !this.c;
			//发事件到父组件
			//this.$emit("collapsed",!this.collapsed);
		}
	}
});
var init = function (){
	var tabsVm = new Vue({
		el:'#allEl',
		data:monitorJson,
		mounted:function(){
			this.$nextTick(function(){
				$('[data-toggle="popover"]').popover();
				//dom 一定更新了 ,第一次绘
				console.log("nextTick-------");
				this.diskParam=this.mTypeList[0].mparam;
				this.licenseParam=this.mTypeList[9].mparam;
				this.openTransactionsParam=this.mTypeList[10].mparam;				
				this.telNumList=this.mTypeList[8].mparam;
				// console.log(this.diskParam);
			});
		},
		methods:{
			diskParamFocus:function(){
				this.diskParam=this.mTypeList[0].mparam;
			},
			diskParamBlur:function(){
				var t = this;
				if (this.diskParam!=this.mTypeList[0].mparam){
					//disk的rowid--->typeid=1
					$.m({ClassName:"websys.MonitorType",MethodName:"saveTypeParam",TypeId:1,Params:this.diskParam},function(rtn){
						if (rtn==1){
							t.mTypeList[0].mparam = t.diskParam;
							t.success = true;
							t.msg="修改成功"
							setTimeout(function(){t.msg=''},3000);
						}else{
							t.success = false;
							t.msg = "修改失败";
						}
					});
				}
			},
			licenseParamFocus:function(){
				this.licenseParam=this.mTypeList[9].mparam;
			},
			licenseParamBlur:function(){
				var t = this;
				if (this.licenseParam!=this.mTypeList[9].mparam){
					$.m({ClassName:"websys.MonitorType",MethodName:"saveTypeParam",TypeId:10,Params:this.licenseParam},function(rtn){
						if (rtn==1){
							t.mTypeList[9].mparam = t.licenseParam;
							t.success = true;
							t.msg="修改成功"
							setTimeout(function(){t.msg=''},3000);
						}else{
							t.success = false;
							t.msg = "修改失败";
						}
					});
				}
			},			
			openTransactionsParamFocus:function(){
				this.openTransactionsParam=this.mTypeList[10].mparam;
			},
			openTransactionsParamBlur:function(){
				var t = this;
				if (this.openTransactionsParam!=this.mTypeList[10].mparam){
					$.m({ClassName:"websys.MonitorType",MethodName:"saveTypeParam",TypeId:11,Params:this.openTransactionsParam},function(rtn){
						if (rtn==1){
							t.mTypeList[10].mparam = t.openTransactionsParam;
							t.success = true;
							t.msg="修改成功"
							setTimeout(function(){t.msg=''},3000);
						}else{
							t.success = false;
							t.msg = "修改失败";
						}
					});
				}
			},
			getServerUrl: function (item) {
				if (item.serverIP) {
					var url = item.servicesProtocol + "://" + item.serverIP + ":" + item.webServerPort + item.serverWebPath + "/dhcservice.Interface.cls?wsdl=1";
					return url;
				}else{
					return "";
				}
			},
			resetMsg:function(){
				this.msg = "";
				this.success = true;
			},
			addServerItem : function(){
				this.resetMsg();
				var item = {};
				item.serverName="";
				item.serverIP=""; //.serverIP="11111"
				item.webServerPort="80";
				item.serverWebPath="/imedical/web"; // "/dthealth/web";
				item.serverType = "E"; 
				item.servicesProtocol = "HTTP";
				item.sslConfig = "";
				item.connectUser = "";
				item.connectPwd = "";
				// 手动监听curServerItem对象
				this.$set(this,"curServerItem",item);
				$("#serverFormWin").modal();
				return false;
			},
			eidtServerItem : function (serverItem){
				this.resetMsg();
				this.curServerItem = serverItem;
				$("#serverFormWin").modal();
			},
			showDelWin : function (serverItem){
				this.resetMsg();
				this.curServerItem = serverItem;
				$("#delServerFormWin").modal();
			},
			delServerItem : function (serverItem){
				this.curServerItem = serverItem;
				var t = this;
				// 类型配置--开/关
				$.m({ClassName:"websys.ServerConfigMgr",MethodName:"Del",
					RowId:serverItem.serverId
				},function(rtn){
					if (rtn==1){
						$("#delServerFormWin").modal("hide");
						//d ##class(ext.util.JsonObject).ClassQuery2Json("websys.ServerConfigMgr","Find")
						$.cm({ClassName:"websys.ServerConfigMgr",QueryName:"Find"},function(rtn){
							t.serverList = rtn.rows;
						});
						t.success = true;
						t.msg="删除成功"
						setTimeout(function(){t.msg=''},3000);
					}else{
						$("#delServerFormWin").modal("hide");
						
						t.success = false;
						t.msg = "删除失败,"+rtn.split("^")[1];
					}
				});
			},
			saveServerItem:function(serverItem){
				var t = this;
				if (/^[^A-Za-z]/.test(serverItem.serverName)){
					t.success = false;
					t.msg = "服务器名只能以字母开头";
					return false;
				}
				if (/\W/.test(serverItem.serverName)){
					t.success = false;
					t.msg = "服务器名不能包含特殊字符";
					return false;
				}
				if (serverItem.servicesProtocol=="HTTPS" && serverItem.sslConfig==""){
					t.success = false;
					t.msg = "HTTPS服务必须填写SSLConfig.至System > Security Management > SSL/TLS Configurations > Edit SSL/TLS Configuration  - (security settings) 配置";
					return false;
				}
				if (!!serverItem.connectUser){
					if (!!serverItem.connectPwd) {
						if(serverItem.connectPwd.length%32>0){ //加过密不再加
							//alert("srcPwd " + serverItem.connectPwd);
							serverItem.connectPwd = e7(serverItem.connectPwd, CONNECT_PWD_KEY);						
							//alert("encPwd " + serverItem.connectPwd);
						}
					} else {
						t.success = false;
						t.msg = "密码不能为空";
						return false;
					}
				}
				$("#saveServerItemSure").html("导入服务中...")
				$("#saveServerItemSure").prop("disabled",true);
				$("#saveServerItemCancel").prop("disabled",true);
				// 服务保存
				$.m({ClassName:"websys.ServerConfigMgr",MethodName:"Save",
					RowId:serverItem.serverId,
					Name:serverItem.serverName,
					ServerIP:serverItem.serverIP,
					WebServerPort:serverItem.webServerPort,
					WebPath:serverItem.serverWebPath,
					Type:serverItem.serverType,
					ServicesProtocol:serverItem.servicesProtocol,
					SSLConfig:serverItem.sslConfig
					,ConnectUser:serverItem.connectUser
					,ConnectPwd:serverItem.connectPwd
				},function(rtn){
					$("#saveServerItemSure").html("确定")
					$("#saveServerItemSure").prop("disabled",false);
					$("#saveServerItemCancel").prop("disabled",false);

					if (rtn>0){
						$("#serverFormWin").modal("hide");
						//d ##class(ext.util.JsonObject).ClassQuery2Json("websys.ServerConfigMgr","Find")
						$.cm({ClassName:"websys.ServerConfigMgr",QueryName:"Find"},function(rtn){
							t.serverList = rtn.rows;
						});
						t.success = true;
						t.msg="设置成功"
						setTimeout(function(){t.msg=''},3000);
					}else{
						t.success = false;
						t.msg = "设置失败。"+rtn.split("^")[1];
					}
				});
			},
			switchTypActive:function(typ){
				var t = this;
				// 类型配置--开/关
				$.m({ClassName:"websys.MonitorType",MethodName:"SwitchTypActive",TypeId:typ.mid},function(rtn){
					if (rtn==1){
						if (typ.mactive=="Y"){
							typ.mactive="N";
						}else{
							typ.mactive="Y";		
						}
						t.success = true;
						t.msg="设置成功"
						setTimeout(function(){t.msg=''},3000);
					}else{
						t.success = false;
						t.msg = "设置失败";
					}
				});
			},
			switchDBParamActive:function(dbp){
				var curTypeItem ,t=this;
				this.mTypeList.forEach(function(item){
					if (item.mtype=="Database"){
						curTypeItem = item;
						return;
					}
				});
				if (dbp.IsActive == 1){
					//dbp.IsActive = 0;
					var ary = curTypeItem.mparam.split("^");
					ary.splice($.inArray(dbp.ValueKey,ary),1);
					curTypeItem.mparam = ary.join("^");
				}else{
					//dbp.IsActive = 1;
					curTypeItem.mparam += "^"+dbp.ValueKey;
				}
				$.m({ClassName:"websys.MonitorType",MethodName:"saveTypeParam",TypeId:curTypeItem.mid,Params:curTypeItem.mparam},function(rtn){
					if (rtn==1){
						if (dbp.IsActive == 1){
							dbp.IsActive = 0;
						}else{
							dbp.IsActive = 1;
						}
						t.success = true;
						t.msg="修改成功"
						setTimeout(function(){t.msg=''},3000);
					}else{
						t.success = false;
						t.msg = "修改失败";
					}
				});
				console.log(curTypeItem.mparam);
			},
			returnPage:function(){
				if ("undefined" == typeof websys_getMWToken) {
					window.open("websys.monitor.csp","_self");					
				} else {
					window.open("websys.monitor.csp" + "?MWToken=" + websys_getMWToken(),"_self");
				}				
			}
		}
	});

	var UserData = [];
	$q({
		ClassName: "web.SSUser",
		QueryName: "ListAll",
		rows: 20000
	}, function (Data) {
		var rowData = Data.rows;
		for (var i = 0; i < rowData.length; i++) {
			var json = {};
			json.id = rowData[i].SSUSRRowId; // HIDDEN
			json.text = rowData[i].SSUSRInitials + "-" + rowData[i].SSUSRName;
			UserData.push(json)
		}
		$("#userListPhone").combobox({
			valueField: 'id',
			textField: 'text',
			multiple: true,
			rowStyle: 'checkbox', //显示成勾选行形式
			panelHeight: "150",
			editable: true,
			defaultFilter: 6,
			data: UserData
			, onShowPanel: function () {
				var vals = monitorJson.mTypeList[8].mparam;
				vals = vals.split(",");
				$("#userListPhone").combobox("setValues", vals);
			}
			, onHidePanel: function () {
				var vals = $("#userListPhone").combobox("getValues");
				vals = vals.join(",");
				if (monitorJson.mTypeList[8].mparam != vals) {
					$.m({ ClassName: "websys.MonitorType", MethodName: "saveTypeParam", TypeId: 9, Params: vals }, function (rtn) {
						var t = tabsVm;
						if (rtn == 1) {
							t.mTypeList[8].mparam = vals;
							t.success = true;
							t.msg = "修改成功"
							setTimeout(function () { t.msg = '' }, 3000);
						} else {
							t.success = false;
							t.msg = "修改失败";
						}
					});
				}
			}
		});
		var vals = monitorJson.mTypeList[8].mparam;
		vals = vals.split(",");
		$("#userListPhone").combobox("setValues", vals);
	});
}
$(init);
