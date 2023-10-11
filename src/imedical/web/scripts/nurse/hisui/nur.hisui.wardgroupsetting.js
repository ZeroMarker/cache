var proObj = "",hospComp="",hospID = session['LOGON.HOSPID'],userID=session['LOGON.USERID'],nurseStr="";
var curGroupedPats=[]; // 存当前组护士已分患者
var allGroupedBeds=[]; // 存所有已分组床位
var setDataGrid;
$(function() {
	var wardid=session['LOGON.WARDID'];	
	hospComp = GenHospComp("Nur_IP_WardProGroupV2",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //获取下拉框的值
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "东华标准版数字化医院[总院]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		getSwitchFlag();
		$('#form').form("load",{
			Name: "",
			Nurse:[]	
		});
		nurseStr="";
		// 获取病区列表
		var wardid=$("#ward").combogrid("getValue")
    	getWardData(wardid,"");
    	GetUngroupedMainNurses("",wardid,"");    
    	reloadDataGrid(wardid,"","","Y");
	}  ///选中事件
	
	$HUI.combogrid('#_HospList',{disabled:wardid ? true : false,})
	
	// 默认分组日期
	var curDate=new Date();
	var year=curDate.getFullYear();
	var month=curDate.getMonth()+1;
	month=month<10 ? "0"+month : month;
	var day=curDate.getDate();		
	$('#createDate').datebox({value:year+"-"+month+"-"+day,});
	
	// 获取病区列表
    getWardData(wardid,"");
    GetUngroupedMainNurses("",wardid,""); 
    initTable();    
    reloadDataGrid(wardid,"","","Y");
	
    // 护理分组权限
    getSwitchFlag();    
    
	// 默认激活
	$("#active").checkbox("check");	
	
	// 加载分管患者列表
	initPatGrid("dg-selected");
	initPatGrid("dg-optional");
	
	// 护理级别颜色提示框
	initTooltip();
})

// 护理分组开关
function onSwitchChange(e,obj){
	$.m({
		ClassName:"Nur.NIS.Service.Base.WardProGroupPatSetting",
		MethodName:"SetNurseGroupFlag",
		flag:obj.value ? "Y" : "N",
		hospID:hospID
	},function testget(result){
		if(result == "0"){
			var sign=obj.value ? "打开" : "关闭";
			$.messager.popover({msg:"护士分管患者权限已"+sign+"！", type:'success'});										
		}
	})
}

function getWardData(wardid,warddesc) {
    $HUI.combogrid("#ward", {
	    idField: "wardid",
	    textField: "warddesc",
	    selectOnNavigation: false,
	    panelHeight: "260",
	    mode:'remote',
	    delay:500,
	    url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew",
	    columns: [[
			{field:'warddesc',title:'病区名称',width:210}
		]],
	    editable: true,
	    disabled:session['LOGON.WARDID'] ? true : false,
	    onClickRow: function (index,record) {
		    nurseStr="";
        	$('#form').form("load",{
				Rowid: "",
				Code: "",
				Name: ""	
			});
        	GetUngroupedMainNurses("",record.wardid,"");
        	searchGroup();
        	getBedList("","",record.wardid);	        
	    },
	    onBeforeLoad:function(param){
		    if(warddesc!=""){
				param['q']=warddesc;
				warddesc=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{desc:desc,hospid:$HUI.combogrid('#_HospList').getValue(),bizTable: "Nur_IP_WardProGroupV2"});
		},
		onLoadSuccess:function(){
			if(wardid){
				$(this).combogrid('setValue', wardid);
				wardid="";	
			}else{
				nurseStr=""
				GetUngroupedMainNurses("","","");
			}	
		}
	});
}

// 获取病区未分组的主管护士，包含选中的激活行的护士及所有未激活行的护士
function GetUngroupedMainNurses(rowID,wardid,nurseName){
	$cm({
            ClassName: "Nur.NIS.Service.Base.WardProGroupPatSetting",
            QueryName: "GetUngroupedMainNurses",
            wardID: wardid,
            hospID: hospID,
            rowID:rowID
        },
        function (obj) {
            var nurseIDStr = "";
            $HUI.combobox("#nurse", {
                valueField: "ID",
                textField: "name",
                multiple: true,
                selectOnNavigation: true,
                panelHeight: "210",
                editable: true,
                data: obj.rows,
                formatter:function(row){  
					var rhtml;
					if(row.selected==true){
						rhtml = row.name+"<span id='i"+row.ID+"' class='icon icon-ok'></span>";
					}else{
						rhtml = row.name+"<span id='i"+row.ID+"' class='icon'></span>";
					}
					return rhtml;
				},
                onChange: function (newval,oldval) {
                    $(this).combobox("panel").find('.icon').removeClass('icon-ok');
					for (var i=0;i<newval.length;i++){
						$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
					}
					nurseStr=newval.join("@");                 
                },
                onLoadSuccess:function(data){
	                // 选中未激活责组，回显责组护士时，判断是否已分管其他激活组，是则提示，并且责组护士框不显示该护士
	                var str=$.trim(nurseStr);
	                if(str!=""){
		                var nurseArr=str.split("@");
		                var newArr=[];
		                var nameArr=nurseName ? nurseName.split(";") : [];
		                if(data.length > 0){
			                data.forEach(function(val,index){				 
				 				if(nurseArr.indexOf(val.ID)>-1){
					 				var index2=nurseArr.indexOf(val.ID)
					 				nurseArr.splice(index2,1);
					 				nameArr.splice(index2,1);
					 				newArr.push(val.ID);	
					 			}	
				 			})
			            }
			            var nameStr="";
			            if(nurseArr.length>0){
				        	data.forEach(function(val,index){
				 				if(nurseArr.indexOf(val.ID)>-1){
					 				nameStr=nameStr=="" ? val.name : nameStr+";"+val.name;
					 			}	
				 			})    
				        }
				        $(this).combobox('setValues', newArr);
				        nurseStr=newArr.join("@");
		            	if(nameArr.length>0){
			            	$.messager.popover({ msg: '护士 '+nameArr.join(" ")+' 已分管其他责组或未激活！', type:'error' });
    						return false;
			            }                   	
	                }		                               
	            } 
            });
        }
    );
}

// 初始化table
function initTable(){
	$('#groupGrid').datagrid({
		fit : true,
		fitColumns:true,
		checkOnSelect:false,
		selectOnCheck:false,
		nowrap:false,
		columns :[[ 
			{field:'ck',title:'',checkbox:true},   
	    	{field:'desc',title:'责组名称',width:100},    
	    	{field:'nurseName',title:'责组护士',width:100},
	    	{field:'nurseLevel',title:'层级',width:80},
	    	{field:'shiftName',title:'班次名称',width:80},
	    	{field:'timeRange',title:'时间段',width:200},
	    	{field:'assignPats',title:'分管患者',width:500,formatter:function(value,row,index){
		    	var desc=""
		    	if(value.length>0){
			    	value.forEach(function(val,ind){
				    	var bedCode=val.bedCode=="等候区" ? val.bedCode : val.bedCode+"床";
				    	desc+='<span style="margin-right:6px;font-weight:bold;color:'+val.careLevelColor+'">'+val.patName+'('+val.bedCode+')</span>';
				    })	
			    }
			    return desc;
		    }},
		    {field:'active',title:'激活',width:36,formatter:function(value,row,index){
		    	return value=="Y" ? $g("是") : $g("否");
		    }},
		    /*
	    	{field:'option',title:'',width:24,formatter:function(value,row,index){
		    	var record=JSON.stringify(row);
		    	return '<a class="btnCls icon-write-order" href="javascript:void(0)" onclick=assignPat(\'' + record + '\')></a>'
		    },styler: function(value,row,index){				
				return 'background-color:#f4f6f5;vertical-align:middle;';
			}}
			*/
		]],
		// pagination : true,  //是否分页
		// pageSize: 15,
		// pageList : [15,30,50],
		// singleSelect : true,
		loadMsg : '加载中..', 
		onCheck:function(rowIndex,rowData){
			// 行多选，复选框单选，为选中行分管患者
			var checkedRows=$(this).datagrid("getChecked");
			var allRows=$(this).datagrid("getRows");
			if(checkedRows.length>0){
				checkedRows.forEach(function(val,index){
					if(val.nurseId!=rowData.nurseId){
						var ind=allRows.findIndex(function(val2){
							return val.nurseId==val2.nurseId;	
						})
						$("#groupGrid").datagrid("uncheckRow",ind);		
					}	
				})	
			}
		},
		onClickRow:function(rowIndex, rowData){
			// 点击一行选中同一组所有行
			var select=$("#groupGrid").datagrid("getSelections")
			$("#groupGrid").datagrid("unselectAll");	
			var rows=$("#groupGrid").datagrid("getRows");
			nurseStr="";
			var nurseName="";
			rows.forEach(function(val,index){
				if(val.rowid==rowData.rowid){
					$("#groupGrid").datagrid("selectRow",index);
					nurseStr=nurseStr=="" ? val.nurseId.toString() : nurseStr+"@"+val.nurseId;	
					nurseName=nurseName=="" ? val.nurseName : nurseName+";"+val.nurseName;
				}	
			})			
			// 选中行回显表单数据
			var rowID=$.trim($("#rowid").val());
			if(rowID!=rowData.rowid){
				//getWardData(rowData.wardid,rowData.warddesc)
				GetUngroupedMainNurses(rowData.rowid,rowData.wardid,nurseName);
			}						
		 	$('#form').form("load",{
		 		Code: rowData.code,
		 		Name: rowData.desc	
	 		});
	 		if(rowData.active == "Y"){
		 		$("#active").checkbox("check");	
		 	}else{	
			 	$("#active").checkbox("uncheck");	
			}				
		}   
	}); 
}

// 列表数据加载
function reloadDataGrid(wardid,code, name, avtiveFlag)
{
	$("#rowid").val("");
	$.cm({
		ClassName:"Nur.NIS.Service.Base.WardProGroupPatSetting",
		MethodName:"WardProGroupList",
		wardid:wardid,
		groupCode:code,
		groupDesc:name,
		activeFlag:avtiveFlag,
		nurIds:nurseStr,
		hospId:hospID
	},function(data){
		$('#groupGrid').datagrid('loadData',data); 
		if(data.length>0){
			data.forEach(function(val,index){
				if(val.rowsNums!==""){					
					$('#groupGrid').datagrid("mergeCells",{index:index,field:"desc",rowspan:val.rowsNums})	
				}	
			})	
		}
	})
};

// 查询病区分组列表
function searchGroup(){
	var code=$.trim($("#code").val());
	var name=$.trim($("#name").val());
	var activeFlag = $("#active").radio('getValue') ? "Y" : "N";
	var wardid=$("#ward").combogrid("getValue");
	reloadDataGrid(wardid,code,name,activeFlag)
}

// 新增/修改责组
function saveWardProGroup(flag){
	var rowid="";
	var rows = $('#groupGrid').datagrid("getSelections");
	if(flag){		
		if (rows.length > 0) {
			var rowid=rows[0].rowid;
		}else{
			$.messager.alert("简单提示", "请选择要修改的分组", "info");
			return;
		}
	}
	var wardid=$("#ward").combogrid("getValue");
	var name=$.trim($("#name").val());
	var activeFlag = $("#active").radio('getValue') ? "Y" : "N";
	if(wardid == "")
	{
		$.messager.popover({ msg: '病区不能为空！', type:'error' });
    	return false;
	}		
	if(name == "")
	{
		$.messager.popover({ msg: '责组名称不能为空！', type:'error' });
    	return false;
	}
	if(nurseStr == "")
	{
		$.messager.popover({ msg: '责组护士不能为空！', type:'error' });
    	return false;
	}
	var allRows=$('#groupGrid').datagrid("getRows");
	var nurseArr=nurseStr.split("@");
	if(allRows.length>0){				
		var repeatFlag=false;
		allRows.forEach(function(val,index){
			if(nurseArr.indexOf(val.nurseId.toString())>-1){
				repeatFlag=true;	
			}	
		})
		if(repeatFlag && !flag)
		{
			$.messager.popover({ msg: '同病区同一护士不能分管多个责组！', type:'error' });
	    	return false;
		}
	}
	// 删除责组护士时，释放对应的分管患者
	var delIDs=[],groupId="";
	rows.forEach(function(val,index){
		if(nurseArr.indexOf((val.nurseId).toString())<0){
			var assignPats=val.assignPats;
			if(assignPats.length>0){
				assignPats.forEach(function(pat){
					delIDs.push(pat.wpgpId);	
				})
				groupId=val.rowid;
			}			
		}	
	});
	if(delIDs.length>0 && groupId!="") savePats([],delIDs,groupId);
	$.m({
		ClassName:"Nur.NIS.Service.Base.WardProGroupPatSetting",
		MethodName:"SaveWardProGroup",
		"rowid":rowid,
		"groupCode":"",
		"groupDesc":name,
		"activFlag":activeFlag,
		"wardDr":wardid,
		"updateUser":userID,
		"nurList":nurseStr,
		"hospId":hospID
	},function testget(result){
		if(result == "0"){
			$.messager.popover({msg:"保存成功！", type:'success'});		
			$('#form').form("load",{
		 		Name: "",
		 		Nurse: []	
	 		});
	 		nurseStr="";
	 		var wardid=$("#ward").combogrid("getValue");
	 		GetUngroupedMainNurses("",wardid,"");	
			reloadDataGrid(wardid,"","",activeFlag);					
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});
}

// 排序
function compare(propertyName){
    return function(a,b){
        var value1 = a[propertyName];
        var value2 = b[propertyName];
        return value1 - value2;
    }
}
// 根据床位数据
function getBedList(rowid,desc,wardid){
	allGroupedBeds=[];
	var html=""; 
	var html2="";
	if(rowid){
		$.m({
			ClassName:"Nur.NIS.Service.Base.GroupSettingV2",
			MethodName:"FindBedList",
			"wardID":wardid
		},function testget(result){	
			var result=JSON.parse(result);			
			curGroupedBeds=[];
			if(result["all"].length>0){
				var key=rowid+"^"+desc;
				var curGroupBed=[];
				var otherGroupBed=[];
				var str="<table>";
				var keyArr=[];
				for(var index in result){	
					if(index!="all"){
						if(index==key){
							curGroupedBeds=result[index];
							result[index].forEach(function(val,ind){
								curGroupBed.push(val.bedCode);
								allGroupedBeds.push(val);
							})
						}else{
							result[index].forEach(function(val,ind){
								otherGroupBed.push(val.bedCode);
								allGroupedBeds.push(val);
							})						
						}
						keyArr.push(index);
					}			
				}
				var groupedBed={
					"cur": curGroupBed,
					"other":otherGroupBed
				}
				// 管理组（包含所有床位）
				var allBeds=result["all"].sort(compare("bedCode"))
				allBeds.forEach(function(val,index){
					if(groupedBed["cur"].indexOf(val.bedCode)>-1){
						html+='<li class="cur grouped active" data-bedid="'+val.pacBedID+'">'+val.bedCode+'</li>';
					}else if(groupedBed["other"].indexOf(val.bedCode)>-1){
						html+='<li class="other grouped" data-bedid="'+val.pacBedID+'">'+val.bedCode+'</li>';
					}else{
						html+='<li data-bedid="'+val.pacBedID+'">'+val.bedCode+'</li>';
					}	
				})			
				
				// 已分组
				if(keyArr.length==0){
					html2+='<tr><td><div class="beds">'
					html2+='<p style="height:30px;line-height:30px;border-bottom:1px solid #ccc;text-align:center;">全部患者（'+result["all"].length+'）</p>';
					html2+='<p style="text-align:center; height:60px;line-height:60px;">不分组</p></td></tr>';
				}else{			
					for(var i=0;i<keyArr.length;i++){
						if(i%3==0){
							if(i!=0){
								html2+='</tr>';
							}
							html2+='<tr>';						
						}
						if(i>=3 && i+1==keyArr.length && ((i+1)%3==1 || (i+1)%3==2)){
							html2+='<td class="borderRight">'
						}else{
							html2+='<td>'
						}
						html2+='<div class="beds">';	
						html2+='<p style="height:30px;line-height:30px;border-bottom:1px solid #ccc;text-align:center;">'+keyArr[i].split("^")[1]+'（'+result[keyArr[i]].length+'）</p>';
						html2+='<ul>';
						var arr=result[keyArr[i]].sort(compare("bedCode"));
						arr.forEach(function(val,index){
							html2+="<li>"+val.bedCode+"</li>";	
						})
						html2+='</ul></div></td>';	
					}
					html2+="</tr>";
				}			
			}
			$(".edit-area .beds ul").html(html);  // 管理组（包含所有床位）
			$(".preview-area table").html(html2); // 已分组
		})
	}else{
		$(".edit-area .beds ul").html(html);  // 管理组（包含所有床位）
		$(".preview-area table").html(html2); // 已分组
	}	
}

// 保存当前责组已选中床位
function saveGroupPats(){
	var activeFlag = $("#active").radio('getValue') ? "Y" : "N";
	if(activeFlag=="Y"){
		var selectedPats=[];
		var selectedBedCode=[];
		var selectedRows=$("#dg-selected").datagrid("getRows");
		if(selectedRows.length>0){
			selectedRows.forEach(function(val,key){
				selectedPats.push(val.episodeID);
			})	
		}
		// 当前组删除的已保存的床位
		var delIDs=[];
		var array=JSON.parse(curGroupedPats);
		if(array.length>0){
			array.forEach(function(val,key){
				var index=selectedPats.indexOf(val.episodeID);
	        	if (index == -1) {
		        	delIDs.push(val.wpgpId);
	        	}
	      	})
		}
		
		// 要调整的床位		
		var str="";
		selectedRows.forEach(function(val,index){
			if(val.nurseId && val.nurseId!=assignRow.nurseId){
				str=str=="" ? val.bedCode+"床 "+val.patName : str+"、"+val.bedCode+"床 "+val.patName;
			}
		});
		if(str!=""){			
			var msg=str+"已分配，是否确认调整？";
			$.messager.confirm("简单提示", msg, function (r) {
				if (r) {
					savePats(selectedPats,delIDs);
				}
			});				
		}else{
			savePats(selectedPats,delIDs);
		}	
	}else{
		$.messager.popover({ msg: "该责组未激活！", type:'error' });		
	}	
}

// 不分组
function resetBeds(){
	var rowID=$.trim($("#rowid").val());
	var desc=$.trim($("#name").val());
	var selectedBeds=[];
	var delBeds=[];
	var delBedCode=[];
	if(allGroupedBeds.length > 0){
		allGroupedBeds.forEach(function(val,index){
			delBeds.push(val.rowid);
			delBedCode.push(val.bedCode);
		})		
		var str=delBedCode.sort().join("、");					
		var msg=str+"床已分组，是否确认调整？";
		$.messager.confirm("简单提示", msg, function (r) {
			if (r) {
				saveBeds(rowID,desc,selectedBeds,delBeds,1);
			}
		});					
	}
}

function savePats(selectedPats,delIDs,groupId){
	$.m({
		ClassName:"Nur.NIS.Service.Base.WardProGroupPatSetting",	
		MethodName:"SaveWardProGroupPat",
		groupID:groupId ? groupId : assignRow.rowid,
		nurseID:assignRow.nurseId,
		addPats:JSON.stringify(selectedPats),
		delIDs:JSON.stringify(delIDs),
		updateUser:userID
	},function testget(result){
		if(result == "0"){
			$.messager.popover({msg:"保存成功！", type:'success'});	
			$('#dialog-pat').dialog("close");
			clearForm();
			searchGroup();
		}else{
			$.messager.popover({ msg: result, type:'error' });		
		}
	})
}

function getSwitchFlag(){
	switchFlag=$.m({
		ClassName:"Nur.NIS.Service.Base.WardProGroupPatSetting",
		MethodName:"GetNurseGroupFlag",
		hospID:hospID
	},false)
	// 护理分组权限
    var flag=switchFlag == "Y" ? true : false;
    $HUI.switchbox("#switch").setValue(flag);
}

// 分管患者
var assignRow={};
function assignPat(){
	//var record=JSON.parse(record)
	var rows=$("#groupGrid").datagrid("getChecked");	
	if(rows.length>0){
		assignRow=rows[0];
		if(assignRow.active!="Y") return $.messager.popover({ msg: "分组未激活，不能分管患者！", type:'alert' });
		$('#dialog-pat').dialog("open");
		$("#toolbar").html('<input id="keywords" placeholder="请输入姓名、床号" />');
		$("#toolbar2").html('<input id="keywords2" placeholder="请输入姓名、床号" />');
		$('#keywords').searchbox({
			searcher: function(value) {
				searchPats("dg-selected",value);
			}
		});
		$('#keywords2').searchbox({
			searcher: function(value) {
				searchPats("dg-optional",value);
			}
		});	
		var title=assignRow.nurseName;
		if(assignRow.nurseLevel) title+="/"+assignRow.nurseLevel;
		if(assignRow.shiftName) title+="/"+assignRow.shiftName;
		if(assignRow.timeRange) title+="/"+assignRow.timeRange;
		$('#dialog-pat p.title').html(title);
		reloadSavedPatData("");
		reloadOptionalPatData("");
	}else{
		$.messager.popover({ msg: "请选择一条数据！", type:'info' });		
	}
}

// 查询患者
function searchPats(tableId,keyword){
	var allPatsList=tableId=="dg-selected" ? curSelectedPatsList : curOptionalPatsList;
	var newPatsList=[];
	if(keyword!=""){
		if(allPatsList.length>0){
			allPatsList.forEach(function(val,index){
				var bedCode=val["bedCode"].toString();
				var patName=val["patName"].toString();
				if(bedCode.indexOf(keyword)!=-1 || patName.indexOf(keyword)!=-1){
					newPatsList.push(val);	
				}	
			})	
		}	
	}else{
		newPatsList=tableId=="dg-selected" ? curSelectedPatsList : curOptionalPatsList;
	}				
	$("#"+tableId).datagrid("loadData",newPatsList);	
}

// 初始化患者列表
function initPatGrid(tableId){
	$("#"+tableId).datagrid({
		fit:true,
		fitColumns:true,
		rownumbers:true,
		border:false,
		toolbar:tableId=="dg-selected" ? "#toolbar" : "#toolbar2",
		columns :[[ 
	    	{field:'patName',title:'患者姓名',width:100,styler:function(value,row,index){
		    	var color=row.careLevelColor ? row.careLevelColor : "";
		    	return 'color:'+color;
		    }},    
	    	{field:'bedCode',title:'床号',width:60},
	    	{field:'illness',title:'病情',width:120},
	    	{field:'groupDesc',title:'分组',width:100}
		]]	
	})	
}

// 加载已选患者
var curSelectedPatsList=[],curOptionalPatsList=[];
function reloadSavedPatData(desc){
	$.cm({
		ClassName:"Nur.NIS.Service.Base.WardProGroupPatSetting",
		MethodName:"GetSavedPatList",
		groupID:assignRow.rowid,
		nurseID:assignRow.nurseId,
		keyword:desc
	},function(data){
		curGroupedPats=JSON.stringify(data);
		curSelectedPatsList=data;
		$("#dg-selected").datagrid('loadData',data); 
	})		
}

// 加载可选患者
function reloadOptionalPatData(desc){
	var savedWPGPIDStr="^";
	var assignPats=assignRow.assignPats;
	if(assignRow.assignPats.length>0){
		assignPats.forEach(function(val,index){
			savedWPGPIDStr=savedWPGPIDStr+val.wpgpId+"^"	
		})	
	}
	$.cm({
		ClassName:"Nur.NIS.Service.Base.WardProGroupPatSetting",
		MethodName:"GetOptionalPatList",
		wardID:assignRow.wardid,
		savedWPGPIDStr:savedWPGPIDStr,
		keyword:desc
	},function(data){
		curOptionalPatsList=data;
		$("#dg-optional").datagrid('loadData',data); 
	})		
}

// 左移
function MoveLeft(){
	var rows=$("#dg-optional").datagrid("getSelections");
	if(rows.length==0){
		return $.messager.popover({ msg: "请选择要左移的患者！", type:'alert' });	
	}else{
		var movePats=[];
		rows.forEach(function(val,key){
//			$("#dg-selected").datagrid("appendRow",val);
//			var index=$("#dg-optional").datagrid("getRowIndex",val);
//			$("#dg-optional").datagrid("deleteRow",index);
			curSelectedPatsList.push(val);
			movePats.push(val.episodeID);							
		})
		curOptionalPatsList=curOptionalPatsList.filter(function(val,index){
			return movePats.indexOf(val.episodeID)==-1;
		});		
	}
	var desc=$('#keywords').searchbox('getValue');
	searchPats("dg-selected",desc);
	var desc2=$("#keywords2").searchbox("getValue");
	searchPats("dg-optional",desc2);	
}
// 右移
function MoveRight(){
	var rows=$("#dg-selected").datagrid("getSelections");
	if(rows.length==0){
		return $.messager.popover({ msg: "请选择要右移的患者！", type:'alert' });	
	}else{
		var movePats=[];
		rows.forEach(function(val,key){		
//			$("#dg-optional").datagrid("appendRow",val);
//			var index=$("#dg-selected").datagrid("getRowIndex",val);
//			$("#dg-selected").datagrid("deleteRow",index);	
			curOptionalPatsList.push(val);
			movePats.push(val.episodeID);				
		})	
		curSelectedPatsList=curSelectedPatsList.filter(function(val,index){
			return movePats.indexOf(val.episodeID)==-1;
		});		
	}
	var desc=$('#keywords').searchbox('getValue');
	searchPats("dg-selected",desc);
	var desc2=$("#keywords2").searchbox("getValue");
	searchPats("dg-optional",desc2);
}

// 清空
function clearForm(){
	$("#groupGrid").datagrid("unselectAll");
	$('#form').form("load",{
		Name: "",
		Nurse:[]	
	});
}

// 初始化提示框
function initTooltip(){
	runClassMethod("Nur.NIS.Service.Base.WardProGroupPatSetting","GetAllCareLevelV2",{"category":1},function(data){
		var html="<div>";
		for(i=0; i<data.length; i++){
			html+='<p style="line-height:26px;"><span style="display:inline-block;margin-right:6px;vertical-align:middle;height:16px;width:16px;background-color:'+data[i].color+'"></span>'+data[i].careLevel+'</p>';
		}
		html+="</div>";
		$('#tooltip').popover({  
			placement:"bottom",    
			content:html,
			width:99,
			trigger:"hover"
		});
	},'json',false);
} 

// 打印
function printWardProGroup(){
	var dateTime=getServerTime();	
	var rows=$('#groupGrid').datagrid('getRows'); 	
	if(rows.length>0){
		var wardDesc=rows[0].warddesc;
		var LODOP=getLodop();		
		LODOP.PRINT_INIT("护士分组");
		LODOP.SET_PRINT_PAGESIZE(1,"210mm","297mm","A4")
		var headStr="<thead><tr><td>责组名称</td><td>责组护士</td><td>层级</td><td>班次名称</td><td>时间段</td><td>分管患者</td></tr></thead>";	
		var bodyStr="<tbody>";
		rows.forEach(function(val){			
			var assignPats=val.assignPats;
			patStr="";
			if(assignPats.length>0){
				assignPats.forEach(function(pat){
					var bedCode=pat.bedCode=="等候区" ? pat.bedCode : pat.bedCode+"床";
					patStr=patStr=="" ? pat.patName+"("+bedCode+")"	: patStr+","+pat.patName+"("+bedCode+")";
				})	
			}
			if(val.rowsNums!=""){
				bodyStr=bodyStr+'<tr>'+'<td rowspan="'+val.rowsNums+'" width="70">'+val.desc+'</td>'+'<td width="100">'+val.nurseName+'</td>'+'<td width="50">'+val.nurseLevel+'</td>'+'<td width="70">'+val.shiftName+'</td>'+'<td width="60">'+val.timeRange+'</td>'+'<td>'+patStr+'</td>'+'</tr>';	
			}else{
				bodyStr=bodyStr+'<tr>'+'<td>'+val.nurseName+'</td>'+'<td>'+val.nurseLevel+'</td>'+'<td>'+val.shiftName+'</td>'+'<td>'+val.timeRange+'</td>'+'<td>'+patStr+'</td>'+'</tr>';	
			}
		})
		bodyStr=bodyStr+"</tbody>";
		var strHTML = '<style>table,th{border:none;font-weight:normal;} td{border: 1px solid #000;} thead td{font-weight:bold;text-align:center;}</style>"<table style="border-collapse:collapse;" border=0 cellSpacing=0 cellPadding=0  width="100%" bordercolor="#000000">'+headStr+bodyStr+"</table>";
		LODOP.ADD_PRINT_TEXT(40,0,"100%",42,"护士分组");
		LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
		LODOP.SET_PRINT_STYLEA(0,"FontSize",12);
		LODOP.SET_PRINT_STYLEA(0,"Bold",1);
		LODOP.ADD_PRINT_TEXT(66,206,180,22,"日期:"+dateTime.date);
		LODOP.ADD_PRINT_TEXT(66,406,160,22,"病区:"+wardDesc);
		LODOP.ADD_PRINT_TABLE("22mm","5mm","190mm","280mm",strHTML);
		LODOP.SET_PRINT_STYLEA(0,"TableHeightScope",1);				
		LODOP.PRINT();	
	}else{
		$.messager.popover({msg: '暂无数据！',type:'alert'});
	}	
}