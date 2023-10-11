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
			//���¼��������
			//this.$emit("collapsed",!this.collapsed);
		}
	}
});
var needPosition = function (mtype) {
	if (mtype == 'Task') return false;
	if (mtype == 'QryClientList') return false;
	if (mtype == 'OpenTransactions') return false;
	if (mtype == 'TimeCheck') return false;
	return true;
};
var serverOption = {
    title: {
        text: '�������ṹ'
    },
    tooltip: {},
    animationDurationUpdate: 1500,
    animationEasingUpdate: 'quinticInOut',
    series : [
        {
            type: 'graph',
            layout: 'none',
            symbolSize: 50,
            roam: true,
            label: {
                normal: {
                    show: true
                }
            },
            edgeSymbol: ['circle', 'arrow'],
            edgeSymbolSize: [4, 10],
            edgeLabel: {
                normal: {
                    textStyle: {
                        fontSize: 20
                    }
                }
            },
            data: [{
                name: 'С��',
                symbol : 'roundRect',
                icon : 'rect', //'circle', 'rect', 'roundRect', 'triangle', 'diamond', 'pin', 'arrow'
                x: 300,
                y: 300
            }, {
                name: 'ECP1',
                symbol : 'roundRect',
                x: 550,
                y: 300
            }, {
                name: 'ECP2',
                symbol : 'roundRect',
                x: 550,
                y: 100
            }, {
                name: 'shadow',
                symbol : 'roundRect',
                x: 550,
                y: 500
            }],
            // links: [],
            links: [{
                source: 0,
                target: 1,
                symbolSize: [5, 5],
                label: {
                    normal: {
                        show: false
                    }
                },
                lineStyle: {
                    normal: {
                        width: 2,
                        curveness: 0
                    }
                }
            }, {
                source: 'С��',
                target: 'ECP2',
                label: {
                    normal: {
                        show: false
                    }
                },
                lineStyle: {
                    normal: { curveness: 0 }
                }
            }, {
                source: 'С��',
                target: 'shadow',
                lineStyle: {
                    normal: { curveness: 0 }
                }
            }],
            lineStyle: {
                normal: {
                    opacity: 0.9,
                    width: 2,
                    curveness: 0
                }
            }
        }
    ]
};
/*������Option*/
var lineOpt = { title: {text: ''},
	tooltip: {
        trigger: 'axis'
        ,backgroundColor:'#d4d4d4'
        //,formatter:function(params,ticket,callback){}
        ,axisPointer: {animation: false,label: {backgroundColor: '#505765'}}
    },
    legend: {data:[]},
    grid: { left: '3%', right: '8%', bottom: '5%', containLabel: true},
    toolbox: {feature: {magicType: {type: ['line', 'bar']} }  },
    xAxis: {type:'category', boundaryGap: false ,data: []},
    yAxis: {name:"",type: 'value' }
};
var drawByServerAndType = function(serverId,typeItem){
	var opt={};
	$.extend(true,opt,lineOpt);
	if (typeItem.mtype=="Task") {
		var curDate = new Date();
		var curDateStr = getFormatDate(curDate);
		var sDate = mutil.zdh(curDateStr,3);
		// �л���ʱ��Ҫ��ʼ������
		var beforeDate = getNextDate(curDate, -1);
		var eDate = mutil.zdh(beforeDate,3);
		monitorJson.taskStDate = beforeDate;
		monitorJson.taskEndDate = curDateStr;
		monitorJson.showErrorTaskFlag = true;
		monitorJson.taskList=[];
		$.q({ClassName:"websys.MonitorDataMgr",QueryName:"Find",StDate:sDate,EndDate:sDate,TypeDr:typeItem.mid,ServerId:serverId},
		function(json){
			monitorJson.taskList=[];
			for (var i=0;i<json.rows.length;i++){
				if (json.rows[i].Value==1 && monitorJson.showErrorTaskFlag) continue;
				monitorJson.taskList.push(json.rows[i]);
			}
		})
	}else{
		/* ((24 hour * 60 min)*7 day) / 5 min = 2016 => {rows:1000 modify rows:2020} */
		$.q({ClassName:"websys.MonitorDataMgr",QueryName:"Find",TypeDr:typeItem.mid,ServerId:serverId,rows:2020}, 
		function(json){
			opt.title.text=typeItem.mname;
			opt.tooltip.position=function(point, params, dom, rect, size){
		        //����pointΪ��ǰ����λ�ã�size�����������ԣ�viewSize��contentSize���ֱ�Ϊ���div��tooltip��ʾ��Ĵ�С
		        var x = point[0];//
		        var y = point[1];
		        var viewWidth = size.viewSize[0];
		        var viewHeight = size.viewSize[1];
		        var boxWidth = size.contentSize[0];
		        var boxHeight = size.contentSize[1];
		        var posX = 0;//x����λ��
		        var posY = 0;//y����λ��
		        if(x<boxWidth){//��߷Ų���
		            posX = 5;    
		        }else{//��߷ŵ���
		            posX = x-boxWidth; 
		        }
		        if(y<boxHeight){//�ϱ߷Ų���
		            posY = 5; 
		        }else{//�ϱ߷ŵ���
		            posY = y-boxHeight;
		        }
		        return [posX,posY];
 
			};
    		opt.tooltip.formatter=function(params,ticket,callback){
			var dateString = params[0].axisValue
			var html='<table class="table">'+typeItem.mtipTitle;
			html += "<caption>" + dateString + "</caption>";
		        try{
			        params.forEach(function(item,index){
				         var seriesName = item['seriesName'];
				         for (var i=0;i<opt.series.length; i++){
					         if (opt.series[i].name==seriesName){
				         		if (opt.series[i].myhtml.length>0){
					        		html += opt.series[i].myhtml[item.dataIndex];
				         		}
					         }
				         }
			        });
		        }catch(e){
			        throw(typeItem.mtype+" tip error."+e);
		        }
	        	//callback(ticket,html);
	        	//console.log(html);
	        	return html+'</table>';
	        }
	        opt.yAxis.name=typeItem.yAxisName;
	        opt.xAxis.data=[];
			opt.legend.data=[]; 		//[{name:'��ֵ��',symbolSize:'0',lineStyle:{normal:{width:1,type:"dashed",opacity:0.4}}}];
			opt.series=[];
	        if (typeItem.mtype=="Disk" || typeItem.mtype=="License"){
		        opt.yAxis.max=100;
		        opt.yAxis.min=0;
		        opt.yAxis.axisLabel={formatter: '{value}%'}
				opt.series=[
		    		{name:"��ֵ��",symbolSize:'0',lineStyle:{normal:{width:1,type:"dashed",opacity:0.4}},type:'line',data:[],myhtml:[]} /*dashed,solid,dotted*/
		   		]
	        }
			json.rows.forEach(function(item,index){
				var arr = item.Time.split(":");
				item.Time = arr[0]+":"+arr[1]; //��ͬ����������ʱ���1��,ʱ���ȵ���
				if (opt.xAxis.data.indexOf(item.Date+"\n"+item.Time)==-1){
					opt.xAxis.data.push(item.Date+"\n"+item.Time); 			//����X��
				}
				if (opt.legend.data.indexOf(item.SubType)==-1){
					opt.legend.data.push(item.SubType);					 //�������̷�
					opt.series.push({name:item.SubType,type:'line',data:[],myhtml:[]});
				}
				for (var i=0; i<opt.series.length; i++){
					if(opt.series[i].name==item.SubType){
						if (typeItem.mtype=="Disk" || typeItem.mtype=="License"){
							 opt.series[i].data.push(item.Value.split("%")[0]);
						}else{
							 opt.series[i].data.push(item.Value);
						}
						opt.series[i].myhtml.push(item.MyHtml);
					}
				}
			});
			if (typeItem.mtype=="Disk" || typeItem.mtype=="License" ){  //ֻ��Disk����
				if(opt.series.length>1){
					for (var i=0;i<opt.series[1].data.length;i++){
						opt.series[0].data.push("90");
					}
				}
			}
			//console.dir(opt);
			chartList[typeItem.mtype].setOption(opt,true);
		});
	}
};
function needDraw(serverType, mtype) {
	//  DB,ECP,MainWEB,Shadow", ",D,E,M,S"
	if (mtype == 'QryClientList') return false;
	if (mtype == 'OpenTransactions') return false;
	if (mtype == 'TimeCheck') return false;
	if (mtype == 'Task') {
		return serverType == "M" || serverType == "D";
	}
	if (mtype == 'Shadow') {
		return serverType == "M" || serverType == "S";
	}
	if (mtype == 'PatFeeCheck') {
		return serverType == "M" || serverType == "S";
	}
	if (mtype == 'License') {
		return serverType != "D";
	}
	return true;
}
var drawServer = function (server,typeList){
	//�Ȳ�������
	//ServerChart = echarts.init(document.getElementById('ServerInfo'));
	//ServerChart.setOption(serverOption);
	typeList.forEach(function(item,index){
		// ���ĸ��������� ��������
		if (item.mactive=='Y' && needDraw(server.serverType, item.mtype)){
			drawByServerAndType(server.serverId,item);			
		} else {
			if (chartList[item.mtype]) { // �������ҳǩ�ľ����ݡ�
				var opt={};
				$.extend(true,opt,lineOpt);
				chartList[item.mtype].setOption(opt, true);
			}
		}
	});
	//drawDisk(server.serverId);
	//drawDisk(server.serverId);
	//drawCosolelog(server.serverId);
	//drawWij(server.serverId);
	//drawDatabase(server.serverId);
	if(server.serverType == "M") {
		var curDate = new Date();
		monitorJson.clientStDate = getNextDate(curDate, -1);
		monitorJson.clientEndDate = getFormatDate(curDate);
		monitorJson.clientList=[];
		$("#clientList").show();
	} else {
		$("#clientList").hide();
	}
	if(server.serverType == "M" || server.serverType == "D" ) {
		$("#tasklist").show();
	} else {
		$("#tasklist").hide();
	}	
}	
var chartList={};
var init = function (){
	var tabsVm = new Vue({
		el:'#allEl',
		data:monitorJson,
		mounted:function(){
			var that = this;
			this.$nextTick(function(){
				$('[data-toggle="popover"]').popover();
				//dom һ�������� ,��һ�λ�
				// draw first server 
				this.draw(this.serverList.length>0?this.serverList[0]:null); //this.curServer);
				that.ccheight = document.body.clientHeight - $(".m-chartcontainer").offset().top;
				this.mTypeList.forEach (function(item, index){
					if (item.mactive=='Y' && needPosition(item.mtype)){
						// ��ʼ���������͵�ͼ��
						chartList[item.mtype] = echarts.init(document.getElementById(item.mtype));
					}
				});
			});
			window.onresize =function(){
				// �仯̫Ƶ��,��watch-����
                that.ccheight = document.body.clientHeight- $(".m-chartcontainer").offset().top;
			}
		},
		watch:{
			ccheight:function(val) {
                if (!this.timer) {
                    this.ccheight = val
                    this.timer = true
                    var that = this
                    setTimeout(function () {
                        that.timer = false
                    }, 400)
                }
            }
		},
		computed:{
			collapseErrorStyle:function(){
				return {
					display:this.collapseErrorFlag?'none':'block'
				};
			},
			collapseErrorHeight:function(){
				return {
					height:this.collapseErrorFlag?'66px':'100%'
				};
			}
		},
		methods:{
			needPosition:needPosition,
			draw:function(item){
				if (item.serverId!=this.curServer.serverId){
					//var oldArr = this.mTypeList;
					//this.mTypeList=[];
					//this.mTypeList=oldArr;
					this.curServer=item
					drawServer(this.curServer,this.mTypeList);
				}
			},
			audit:function(id){
				this.curAuditId = id;
				$("#audiowin").modal();
				$('#audiowin').on("shown.bs.modal",function(e){
        			// ��ģ̬�㵯��֮������Ӧ�Ķ�������ָ���ı����ȡ����
					$("#auditUserName").focus();
				});				
			},
			auditLog:function(){
				var _t = this;
				var list = this.alertInfoList;
				var curAuditId = this.curAuditId;
				var username = $("#auditUserName").val();
				if (username==""){
					alert("��ǩ����ȷ��");
					$("#auditUserName").focus();
					return ;
				}
				if (curAuditId>0 || curAuditId == "ALL"){
					//audit error
					$.m({ClassName:"websys.MonitorDataAuditMgr", MethodName:"AlertAudit", 
						MonitorRowId:this.curAuditId, UserName:username},
						function(rtn){
							if (rtn==1){
								if(curAuditId == "ALL"){
									list.splice(0);											
									_t.alertInfoCount = 0;							
								} else {									
									list.forEach(function(item,ind){
										if (item.RowId==curAuditId){
											list.splice(ind,1);
											return false;
										}
									});
									_t.alertInfoCount--;
								}
								$("#audiowin").modal("hide");
							}else{
								_t.modalmsg="�����Ϣ����ʧ��!!";
								$("#alertwin").modal();
							}
					});
				}else{
					//checkin
					$.m({ClassName:"websys.MonitorDataAuditMgr", MethodName:"CheckIn", UserName:username},
						function(rtn){
							if (rtn==1){
								$("#audiowin").modal("hide");
								_t.modalmsg="�ճ����ǩ���ɹ�!";
								$("#alertwin").modal();
							}else{
								_t.modalmsg="�ճ����ǩ��ʧ��!!";
								$("#alertwin").modal();
							}
					});
				}
			},
			checkin:function(){
				this.curAuditId = "";
				$("#audiowin").modal();
			},
			cfg:function(){
				/*
				$('#typwin').modal();
				$('[data-toggle="popover"]').popover();
				*/				
				if ("undefined" == typeof websys_getMWToken) {
					window.open("websys.monitor.cfg.csp","_self");				
				} else {
					window.open("websys.monitor.cfg.csp" + "?MWToken=" + websys_getMWToken(),"_self");
				}
			},
			collapseError:function(){
				this.collapseErrorFlag = !this.collapseErrorFlag;
				if (this.collapseErrorFlag){
					this.collapseErrorBtnTitle = "չ��";
				}else{
					this.collapseErrorBtnTitle = "����"
				}
			},
			typeParamSetting:function(typ){
				console.dir(typ);
				if (typ.mtype=="Disk"){
					this.currentparam.id = typ.mid;
					this.currentparam.name = "����ʹ�÷�ֵ";
					this.currentparam.value = typ.mparam;
					this.currentparam.desc = "";
					$("#typparamwin").modal();
				}else if(typ.mtype=="Database"){
					this.currentparam.id = typ.mid;
					this.currentparam.name = "Database";
					this.currentparam.value = typ.mparam;
					this.currentparam.desc = "";
					$("#typdbparamwin").modal();
				}
			},
			saveTypeParam:function(curparam){
				var t = this;
				console.dir(curparam);
				var curTypeItem;
				this.mTypeList.forEach(function(item){
					if (item.mid==curparam.id){
						curTypeItem = item; //item.mparam = curparam.value; //��ǰ���б���ֵ�仯
						return;
					}
				});
				if (curparam.value != curTypeItem.mparam){
					$.m({ClassName:"websys.MonitorType",MethodName:"saveTypeParam",TypeId:curparam.id,Params:curparam.value},function(rtn){
						if (rtn==1){
							curTypeItem.mparam = curparam.value;
							/*t.mTypeList.forEach(function(item){
								if (item.mid==curparam.id){
									item.mparam = curparam.value; //��ǰ���б���ֵ�仯
								}
							});*/
						}
					});
				}
			},
			switchTypActive:function(typ){
				$.m({ClassName:"websys.MonitorType",MethodName:"SwitchTypActive",TypeId:typ.mid},function(rtn){
					if (rtn==1){
						if (typ.mactive=="Y"){
							typ.mactive="N";
						}else{
							typ.mactive="Y";		
						}
					}
				});
			},
			switchDBParamActive:function(dbp){
				var curTypeItem ;
				this.mTypeList.forEach(function(item){
					if (item.mtype=="Database"){
						curTypeItem = item;
						return;
					}
				});
				if (dbp.IsActive == 1){
					dbp.IsActive = 0;
					var ary = curTypeItem.mparam.split("^");
					ary.splice($.inArray(dbp.ValueKey,ary),1);
					curTypeItem.mparam = ary.join("^");
				}else{
					dbp.IsActive = 1;
					curTypeItem.mparam += "^"+dbp.ValueKey;
				}
				this.currentparam.value = curTypeItem.mparam;
				//console.log(curTypeItem.mparam);
			},
			taskTimeConfig:function(){
				var that = this;
				var param = "ServerId=" + this.curServer.serverId;
				param += "&serverName=" + this.curServer.serverName;
				param += "&serverIP=" + this.curServer.serverIP;
				if ("undefined" == typeof websys_getMWToken) {
					window.open("websys.monitor.taskTimecfg.csp?" + param, "_black", "width=800, height=500, top=100, left=300");			
				} else {
					window.open("websys.monitor.taskTimecfg.csp" + "?MWToken=" + websys_getMWToken() + "&" + param, "_black", "width=800, height=500, top=100, left=300");
				}
			},
			showErrorTask:function(){
				var that = this;
				//var curDate = new Date();
				//var curDateStr = curDate.getFullYear()+"-"+(1+curDate.getMonth())+"-"+curDate.getDate();
				var hdate = mutil.zdh(monitorJson.taskEndDate,3);
				var shdate = mutil.zdh(monitorJson.taskStDate,3); //parseFloat(hdate)-7	
				$.q({ClassName:"websys.MonitorDataMgr",QueryName:"Find",rows:5000,StDate:shdate,EndDate:hdate,TypeDr:6,ServerId:this.curServer.serverId},
				function(json){
					monitorJson.taskList=[];
					for (var i=0;i<json.rows.length;i++){
						if (json.rows[i].Value==1 && that.showErrorTaskFlag) continue;
						monitorJson.taskList.push(json.rows[i]);
					}
				})
			},
			showErrorClient:function(){
				var that = this;
				//var curDate = new Date();
				//var curDateStr = curDate.getFullYear()+"-"+(1+curDate.getMonth())+"-"+curDate.getDate();
				var hdate = mutil.zdh(monitorJson.clientEndDate,3);
				var shdate = mutil.zdh(monitorJson.clientStDate,3);
				$.q({ClassName:"websys.MonitorDataMgr",QueryName:"Find",rows:5000,StDate:shdate,EndDate:hdate,TypeDr:9,ServerId:this.curServer.serverId},
				function(json){
					monitorJson.clientList=[];
					for (var i=0;i<json.rows.length;i++){
						// if (json.rows[i].Value==1 && that.showErrorTaskFlag) continue;
						monitorJson.clientList.push(json.rows[i]);
					}
				})
			}
		}
	});
}
$(init);

// date ����ָ�������ڣ���ʽ��2018-09-27
// day ��-1��ʼǰһ�죬��1��ʼ��һ��
// JS��ȡָ�����ڵ�ǰһ�죬��һ��
// ԭ�����ӣ�https://blog.csdn.net/weixin_53545517/article/details/126300288
function getNextDate(date, day) { 
	var dd = new Date(date);
	dd.setDate(dd.getDate() + day);
	var y = dd.getFullYear();
	var m = dd.getMonth() + 1 < 10 ? "0" + (dd.getMonth() + 1) : dd.getMonth() + 1;
	var d = dd.getDate() < 10 ? "0" + dd.getDate() : dd.getDate();
	return y + "-" + m + "-" + d;
};
// ���ڸ�ʽ��
function getFormatDate(date) {
	var dd = new Date(date);
	var y = dd.getFullYear();
	var m = dd.getMonth() + 1 < 10 ? "0" + (dd.getMonth() + 1) : dd.getMonth() + 1;
	var d = dd.getDate() < 10 ? "0" + dd.getDate() : dd.getDate();
	return y + "-" + m + "-" + d;
};
