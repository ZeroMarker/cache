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
				console.log(this.diskParam);
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
			getServerUrl:function(item){
				if (item.serverIP){
					var url = "http://"+item.serverIP+":"+item.webServerPort+item.serverWebPath+"/dhcservice.Interface.cls?wsdl=1";
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
					Type:serverItem.serverType
				},function(rtn){
					$("#saveServerItemSure").html("确定")
					$("#saveServerItemSure").prop("disabled",false);
					$("#saveServerItemCancel").prop("disabled",false);

					if (rtn>1){
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
				window.open("websys.monitor.csp","_self");
			}
		}
	});
}
$(init);

