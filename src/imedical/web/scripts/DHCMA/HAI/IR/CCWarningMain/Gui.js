//页面Gui
var obj = new Object();
function InitWarnMian(){
	obj.selItem = "";
	obj.qryWarnDate = "";
	obj.qryWarnItems = "";
	obj.Is24HourFlag =Is24HourFlag;
	//设置日期为当月1号
	var qryDate=Common_GetDate(new Date());
	Common_SetValue('qryDate',qryDate);
	$("#WarnItem_24Hour").checkbox('setValue',obj.Is24HourFlag);
	
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);	
	obj.WarnItems = function() {
		var WarnItems =$("#WarnItem_FerverName2").html() + "|" + $("#WarnItem_FerverDay2").val() + "|" + $("#WarnItem_FerverCnt2").val();  //发热标准差
		WarnItems += "^" + $("#WarnItem_FerverName").html() + "|" + $("#WarnItem_FerverDay").val() + "|" + $("#WarnItem_FerverCnt").val();  //发热人数
		WarnItems += "^" + $("#WarnItem_BactName").html() + "|" + $("#WarnItem_BactDay").val() + "|" + $("#WarnItem_BactCnt").val();		//同种菌
		WarnItems += "^" + $("#WarnItem_InfSource").html() + "|" + $("#WarnItem_InfSourceDay").val() + "|" + $("#WarnItem_InfSourceCnt").val();		//同种同源多耐
		//感染
		WarnItems += "^" + "相同感染诊断" + "|" + $("#WarnItem_InfDay").val() + "|" + $("#WarnItem_InfCnt").val();
		var IsActive =$("#WarnItem_24Hour").checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		WarnItems += "^入院24H内计入|" + IsActive;
		return WarnItems;
	}
	obj.qryWarnItems = obj.WarnItems();
	obj.qryWarnDate=$("#qryDate").datebox('getValue');
	
	//表格	
	obj.gridWarning = $('#gridWarning').datagrid({
        fit:true,
        //title:'监测结果',
        headerCls:'panel-header-gray',
        iconCls:'icon-resort',
        pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers:true,
        autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        singleSelect:true,
        nowrap:(window.screen.availWidth>1440 ? true :false),
		fitColumns:(window.screen.availWidth>1440 ? true :false),
        loadMsg:'数据加载中...',
		pageSize: 50,
		pageList : [50,100,200,500],
        url:$URL,
        queryParams:{
	        ClassName:'DHCHAI.IRS.CCWarningNewSrv',
	        QueryName:'QryWarnResult',
	        aHospIDs:$("#cboHospital").combobox('getValue'),
			aLocIDs:'',
	        aWarnDate:$("#qryDate").datebox('getValue'),
	        aWarnItems:obj.qryWarnItems
	    },
        columns:[[
        	{ field:"LocDesc",title:"病区名称",width:140,align:'left',
        		/*formatter:function(value,row,index){
					 return '<a href="#" onclick=obj.LocWarning_Click('+row.LocID+')>'+row.LocDesc+'</a>';
				}*/
				formatter:function(value,row,index){
				{
					return '<a href="#" onclick=obj.ShowWardInfo(\''+row.LocID+'\',\''+row.LocDesc+'\')>'+row.LocDesc+'</a>';
				}
			}
        	},
			{ field:"Fever",title:"发热",width:125,align:'left',
				formatter:function(value,row,index){
					var rowData=row.FeverCnt;
					var rowData2=row.FeStandCnt;
					var WarnDays=$("#WarnItem_FerverDay").val();
					var frHtml="";						
					if(rowData>'0'){
						var Status=obj.StatusValue("发热人数",row.LocID);
						if(Status==2){
							frHtml='<div class="common1" style="border-right-color:#C0C0C0;" onclick="obj.ShowWarnChart(\''+"发热人数:发热人数|"+WarnDays+'\',\'' + row.LocID + '\',\'' + WarnDays + '\')"><p class="text" style="width:100px;">发热人数 <strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo("发热人数"'+","+row.LocID+',\'' + WarnDays + '\',0,\'' + Status + '\')>'+rowData+'</strong></p></div>'
						}else{
							frHtml='<div class="common" style="border-right-color:#FFA54A;" onclick="obj.ShowWarnChart(\''+"发热人数:发热人数|"+WarnDays+'\',\'' + row.LocID + '\',\'' + WarnDays + '\')"><p class="text" style="width:100px;">发热人数 <strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo("发热人数"'+","+row.LocID+',\'' + WarnDays + '\',0,\'' + Status + '\')>'+rowData+'</strong></p></div>'
						}
					}
					if(rowData2>'0'){
						var Status=obj.StatusValue("发热标准差",row.LocID);
						if(Status==2){
							frHtml+='<div class="common1 fcrs1" style="border-right-color:#C0C0C0;" onclick="obj.ShowWarnChart(\''+"发热标准差:发热标准差|"+WarnDays+'\',\'' + row.LocID + '\',\'' + WarnDays + '\')"><p class="text" style="width:100px;">发热方差 <strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo("发热标准差"'+","+row.LocID+',\'' + WarnDays + '\',0,\'' + Status + '\')>'+rowData2+'</strong></p></div>'
						}else{
							frHtml+='<div class="common fcrs" style="border-right-color:#FF8160;" onclick="obj.ShowWarnChart(\''+"发热标准差:发热标准差|"+WarnDays+'\',\'' + row.LocID + '\',\'' + WarnDays + '\')"><p class="text" style="width:100px;">发热方差 <strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo("发热标准差"'+","+row.LocID+',\'' + WarnDays + '\',0,\'' + Status + '\')>'+rowData2+'</strong></p></div>'
						}
					} 
					return  frHtml;
				}
			},
			{ field:"InfInfo",title:"相同感染诊断",width:200,align:'left',
				formatter:function(value,row,index){
					if (!value) return;
					var WarnDays=$("#WarnItem_InfDay").val();
					var ssxhHtml="";
					var rowData=value.split("^");
					for(var i=0;i<rowData.length;i++){
						var rows=rowData[i];
						var NameNum=rows.split("#");
						var Name=NameNum[0];
						var Num=NameNum[1];
						if(Num>0){
							var Status=obj.StatusValue(Name,row.LocID);
							if(Status==2){
								Lhtml='<div class="common ssxh1 left" style="border-right-color:#C0C0C0;">'
								ssxhHtml+=Lhtml+'<p class="text" style="width:175px;" onclick="obj.ShowWarnChart(\''+"相同感染诊断:" + Name + '|'+WarnDays+'\',\'' + row.LocID + '\')">'+Name+' <strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo(\'' + Name + '\',\'' + row.LocID + '\',\'' + WarnDays + '\',0,\'' + Status + '\')>'+Num+'</strong></p></div>'

							}else {
								Lhtml='<div class="common ssxh left" style="border-right-color:#00C1FF;">'
								ssxhHtml+=Lhtml+'<p class="text" style="width:175px;" onclick="obj.ShowWarnChart(\''+"相同感染诊断:" + Name + '|'+WarnDays+'\',\'' + row.LocID + '\')">'+Name+' <strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo(\'' + Name + '\',\'' + row.LocID + '\',\'' + WarnDays + '\',0,\'' + Status + '\')>'+Num+'</strong></p></div>'
							}
						} 
					}					
					return  ssxhHtml;
				}
			},
			{ field:"BacteriaInfo",title:"同种菌",width:235,align:'left',
				formatter:function(value,row,index){
					if (!value) return;
					var WarnDays=$("#WarnItem_BactDay").val();
					var tztyjHtml="";
					var rowData=value.split("^");
					for(var i=0;i<rowData.length;i++){
						var rows=rowData[i];
						var NameNum=rows.split("#");
						var Name=NameNum[0];
						var Num=NameNum[1];
						if(Num>0){
							var Status=obj.StatusValue(Name,row.LocID);
							if(Status==2){
								Rhtml='<div class="common tzty1" style="border-right-color:#C0C0C0;">'
								tztyjHtml+=Rhtml+'<p class="text" style="width:210px;" onclick="obj.ShowWarnChart(\''+"检出同种菌:" + Name + '|'+WarnDays+'\',\'' + row.LocID + '\')">'+Name+'<strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo(\'' + Name + '\',\'' + row.LocID + '\',\'' + WarnDays + '\',1,\'' + Status + '\')>'+Num+'</strong></p></div>'
							}else{
								Rhtml='<div class="common tzty" style="border-right-color:#58EB8E;">'

								tztyjHtml+=Rhtml+'<p class="text" style="width:210px;" onclick="obj.ShowWarnChart(\''+"检出同种菌:" + Name + '|'+WarnDays+'\',\'' + row.LocID + '\')">'+Name+'<strong style="margin-right:8px;float:right;" onclick=obj.ShowPatInfo(\'' + Name + '\',\'' + row.LocID + '\',\'' + WarnDays + '\',1,\'' + Status + '\')>'+Num+'</strong></p></div>'
							}
						}						
					}
					return  tztyjHtml;
				}
			},
			{ field:"TZBacteriaInfo",title:"同种同源多耐菌",width:245,align:'left',
				formatter:function(value,row,index){
					if (!value) return;
					var BactHtml="";
					var WarnDays=$("#WarnItem_InfSourceDay").val();
					var rowData=value.split("^");
					for(var i=0;i<rowData.length;i++){
						var rows=rowData[i];
						var NameNum=rows.split("#");
						var Name=NameNum[0];
						var Num=NameNum[1];
						if(Num>0){
							var Status=obj.StatusValue(Name,row.LocID);
							if(Status==2){
								BactHtml+='<div style="float:left;width:240px;height:auto;margin:3px 0px;margin-left: -5px;">'
								BactHtml+=	'<div style="float:left;width:20px;">'
								BactHtml+=		'<div class="common2" style="border-right-color:#C0C0C0;"></div>'
								BactHtml+=	'</div>'
								BactHtml+=	'<div style="float:left;width:220px;height:auto;background:#C0C0C0;color:#fff;">'
								BactHtml+=		'<div style="float:left;width:200px;height:auto;white-space: normal;text-align: left;margin:3px;cursor:pointer;" onclick="obj.ShowWarnChart(\''+"检出同种同源多耐菌:" + Name + '|'+WarnDays+'\',\'' + row.LocID + '\')">'+Name+'</div>'
								BactHtml+=		'<div style="float:left;width:14px;padding:3px 0px;"><strong style="margin-right:5px;float:right;cursor:pointer;" onclick=obj.ShowPatInfo(\'' + Name + '\',\'' + row.LocID + '\',\'' + WarnDays + '\',2,\'' + Status + '\')>'+Num+'</strong></div>'
								BactHtml+=	'</div>'
								BactHtml+='</div>'							
							}else {
								BactHtml+='<div style="float:left;width:240px;height:auto;margin:3px 0px;margin-left: -5px;">'
								BactHtml+=	'<div style="float:left;width:20px;">'
								BactHtml+=		'<div class="common2"></div>'
								BactHtml+=	'</div>'
								BactHtml+=	'<div style="float:left;width:220px;height:auto;background:#58EB8E;color:#fff;">'
								BactHtml+=		'<div style="float:left;width:200px;height:auto;white-space: normal;text-align: left;margin:3px;cursor:pointer;" onclick="obj.ShowWarnChart(\''+"检出同种同源多耐菌:" + Name + '|'+WarnDays+'\',\'' + row.LocID + '\')">'+Name+'</div>'
								BactHtml+=		'<div style="float:left;width:14px;padding:3px 0px;"><strong style="margin-right:5px;float:right;cursor:pointer" onclick=obj.ShowPatInfo(\'' + Name + '\',\'' + row.LocID + '\',\'' + WarnDays + '\',2,\'' + Status + '\')>'+Num+'</strong></div>'
								BactHtml+=	'</div>'
								BactHtml+='</div>'
							}
						}						
					}
					return  BactHtml;
				}
			},
			{ field:"RepInfo",title:"七日内<br>暴发报告情况",width:100,align:'left',
				formatter:function(value,row,index){
					var bfqkHtml="";
					var RepID=obj.GetRepID(row.LocID);
					if (!RepID) return; 
					var RepIDData=RepID.split("^");
					for(var i=0;i<RepIDData.length;i++){
						RepID=RepIDData[i];
						if(RepID>0){
							bfqkHtml+='<span class="oblong" onclick=obj.OpenReport_Click(\''+RepID+'\',\''+row.LocID+'\')>'+RepID+'</span>'
						}
					}
					return  bfqkHtml;					
				}
			}
        ]]
	});
	
	InitWarnMianEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitWarnMian();
});
