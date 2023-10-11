//名称	DHCPESaveCollectSpec.new.hisui.js
//功能  标本采集
//创建	2023.03.10
//创建人  xy

var vRoomRecordID="";
var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID']; 
//根据计算机IP获取诊室ID
function SetRoomInfo()
{
    var Info=GetComputeInfo("IP");  //计算机名称  DHCPECommon.js
    var RoomID=tkMakeServerCall("web.DHCPE.RoomManager","GetRoomIDByCompute",Info);
   
    if (RoomID=="") return false;
    $("#RoomID").val(RoomID.split("$")[0]);
}


$(function() {
    //根据计算机IP获取诊室ID
	SetRoomInfo();
	
	if( ConsultingRoom=="N") {
		$("#CallDiv").layout("remove","west")
	}
	else{
		document.getElementById("CallDiv").style.display = "";
	}
	
	//初始化叫号列表
	InitCallVoiceGrid();
	
	//初始化采集标本列表
	InitSaveCollectSpecGrid();
	
	//查询（叫号）
	$("#CallQuery").click(function(){
    	CallQuery();
    });
    
    $("#CallRegNo").change(function(){
            CallRegNoOnChange();
        });
        
    
    $("#CallRegNo").keydown(function(e) {
            if(e.keyCode==13){
                CallRegNoOnChange();
            }   
        });   
    
       
	//打印
	$("#BPrint").click(function() {
		BPrint_Click();
	});
	
	//全部启用
	$("#BSRRef").click(function() {
		BSRRef_Click();
	});

	//全部取消
	$("#BSARef").click(function() {
		BSARef_Click();
	});

	//保存
	$("#BSave").click(function() {
		Save_Click();
	});

	//撤销预制号
	$("#BCancelPlacerNo").click(function() {
		BCancelPlacerNo_Click();
	});
    
    //标本号回车
	$("#SpecNo").keydown(function(e) {
		if (e.keyCode == 13) {
			SpecNo_Click();
		}

	});
	
	//登记号回车
	$("#RegNo").keydown(function(e) {
		if (e.keyCode == 13) {
			RegNo_Click();
		}

	});

    //预制号回车
	$("#PlacerNo").keydown(function(e) {

		if (e.keyCode == 13) {
			// 获取第一个选中的行
			var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
			if(selectrow==null)
			{
				$.messager.alert("提示","请选择待保存预制号的医嘱",'info');
				return false;
			}
	
			//获取选中行的index
			var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
			//获取当前页的行
			var rows = $('#SaveCollectSpecGrid').datagrid('getRows');
	
			if(selectrow.TSpecNo==""){
				$.messager.alert("提示","标本号为空,不能保存预制号",'info');
				return false;
			}
			if(selectrow.TOSTATDesc!="核实"){
				$.messager.alert("提示","医嘱不是核实状态,不能保存预制号",'info');
				return false;
			}
			if (selectrow.TOEORIRowId!=""){
		
				var	Strings=selectrow.TOEORIRowId+";"+$("#PlacerNo").val()+";"+selectrow.TSpecNo;
			
			}
	
			var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"N");
	
			if(flag!=0){
				$.messager.alert("提示",flag+",不能再次保存预制号",'info');
				return false;
			}
			if(flag==0){
		
				//更新修改的数据
				$('#SaveCollectSpecGrid').datagrid("updateRow",{
					index:selectindex ,
					row: {
						TPlacesNo: $("#PlacerNo").val(),
		
					}
			});

			var i=selectindex+1;
			$("#PlacerNo").val("");
			//滚动到相应的行
			$('#SaveCollectSpecGrid').datagrid('scrollTo',i);
		
			//选中相应的行
			$('#SaveCollectSpecGrid').datagrid('selectRow',i); 

			}
	
		}

	});

})


//初始化叫号列表
function InitCallVoiceGrid() {
	$HUI.datagrid("#CallVoiceList", {
        url:$URL,
        fit : true,
        border:false,
        showHeader:false,
        pagination:true,
        singleSelect:true,
        pageSize:20,
        showRefresh:false,
        displayMsg:"",
        showPageList:false,
        queryParams:{
            ClassName:"web.DHCPE.ResultNew",
            QueryName:"FindCallVoicePatInfo",
            RegNo:"",
            RoomID:$("#RoomID").val(),
            HospID:session['LOGON.HOSPID']

        },
        columns:[[
      		{field:'PaadmID',hidden:true},
            {field:'PaPatID',hidden:true},
            {field:'PatLabel',title:'',width:240,formatter:setCellLabel},
            {field:'PAPMINo',title:'登记号',width:90,hidden:true},
            {field:'AdmDate',title:'体检日期',width:50,hidden:true},
            {field:'Name',title:'姓名',width:60,hidden:true},
            {field:'Age',title:'年龄',width:50,hidden:true},
            {field:'Sex',title:'性别',width:50,hidden:true},
            {field:'VIPLevel',title:'VIP',width:50,hidden:true},
            {field:'VIPDesc',title:'VIP等级',width:50,hidden:true},
            {field:'Status',title:'状态',width:50,hidden:true},
            {field:'RecordID',width:50,hidden:true},
            {field:'DetailStatus',width:50,hidden:true},
            {field:'RoomDetail',title:'诊室情况',width:100,hidden:true}
        ]],
        onLoadSuccess:function(e){   
       
        	if($("#CallRegNo").val()=="") return false;
            var rows=$('#CallVoiceList').datagrid("getRows");
            if (rows.length > 0) {
            	var row=rows[0];
            	var RoomID=$("#RoomID").val();
                var PAADM=row.PaadmID;
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","CanCheck",RoomID,PAADM);
                if (ret=="1"){
	                $.messager.alert("提示", "存在必须先检查的项目,请先去做相关检查", "info");
                    return false;
                }
                if (ret=="-1"){
	                $.messager.alert("提示", "该诊室已经放弃,不允许操作", "info");
                    return false;
                }
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveByPAADM",RoomID,PAADM);
                
                var Arr=ret.split("^");
                var ret=Arr[0];
                if (ret==""){  //不在当前诊室
                    
                    vRoomRecordID="";
                    return false;
                }else{ //在当前诊室
                    var Record=Arr[0];
                    var Status=Arr[1];
                    var DetailStatus=Arr[2];
                    if (Status=="N"){  //判断是不是同一个人
                        if (DetailStatus==""){ //还没有叫号
                            return false;
                        }
                        if (DetailStatus!="E"){  //不是正检状态的，设置正检，下屏
                            vRoomRecordID=Record;
                            var UserID=session['LOGON.USERID'];
                            var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveCurRoom",Record,UserID,RoomID);
                            return false;
                            
                        }
                        if (DetailStatus=="E"){  //不是正检状态的，设置正检，下屏
                            
                            
                        }
                    }
                    
                    
                }
             
              
            }
        },
        onDblClickRow:function(rowIndex, rowData){

                var HospID=session['LOGON.HOSPID'];
                var RoomID=$("#RoomID").val();
                var PAADM=rowData.PaadmID;
                $("#PAADM").val(PAADM);
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","CanCheck",RoomID,PAADM);
                if (ret=="1"){
	                $.messager.alert("提示", "存在必须先检查的项目,请先去做相关检查", "info");
                    return false;
                }
                if (ret=="-1"){
	                $.messager.alert("提示", "该诊室已经放弃,不允许操作", "info");
                    return false;
                }
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveByPAADM",RoomID,PAADM);
                var Arr=ret.split("^");
                var ret=Arr[0];
                if (ret==""){  //不在当前诊室
                    var TypeFlag=Arr[1];
                    if  (TypeFlag=="2"){
                        if (!confirm("体检者未排队到本诊室,是否查体?")) return false;
                    }else if (TypeFlag=="1"){
                        if (!confirm("已完成本科室检查,是否需要修改?")) return false;
                    }
                    vRoomRecordID="";
                }else{ //在当前诊室
                    var Record=Arr[0];
                    var Status=Arr[1];
                    var DetailStatus=Arr[2];
                    if (Status=="N"){  //判断是不是同一个人
                        if (DetailStatus==""){ //还没有叫号
                            if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;
                        }
                        if (DetailStatus!="E"){  //不是正检状态的，设置正检，下屏
                            var UserID=session['LOGON.USERID'];
                            var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveCurRoom",Record,UserID,RoomID);
                            
                        }
                    }
                    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

                    vRoomRecordID=Record;
                }
        }
   
	})

} 
 
function GetNextInfo(IsCall)
{
    if(IsCall==undefined) IsCall="N";
    var RoomID=$("#RoomID").val();
    if (RoomID=="") 
    {
        $.messager.alert("提示","该诊室未启用排队叫号！","info");
        return false;
    }
    var Info=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetNextInfo",RoomID,IsCall);
    return Info;
}

//呼叫
function Call()
{
    var Info=GetNextInfo("Y");
    var Arr=Info.split("^");
    var RecordID=Arr[0];
    var CallName=Arr[1];
    if (RecordID==""){
        $.messager.alert("提示","没有排队记录！","info");
        return false;
    }
    CallApp(RecordID,CallName);
}

function CallApp(RecordID,CallName)
{
    
    var OldRecord=vRoomRecordID;
    
    if ((OldRecord!=RecordID)&&(OldRecord!=""))
    {
        var Status=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetRecordStatus",OldRecord)
        var StatusArr=Status.split("^");
        var DetailStatus=StatusArr[1];
        var Status=StatusArr[0];
        if (Status=="N"){
            if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
                return false;
            }
        }
    }
    
    
    var rtn=tkMakeServerCall("web.DHCPE.RoomManager","CallCurRoom",RecordID)
    var Arr=rtn.split("^");
    if (Arr[0]!="0"){
	    $.messager.alert("提示",alert(Arr[1]),"info");  
    }
   
    $("#WaitInfo").val("正在呼叫："+CallName);
    vRoomRecordID=RecordID;    
}

//顺延
function Delay()
{
    var HospID=session['LOGON.HOSPID'];
    $.messager.confirm("提示", "确认要顺延吗?", function (r) {
    	if (r) {
        
    		var Info=GetNextInfo();
    		var Arr=Info.split("^");
    		var RecordID=Arr[0];
    
    		if (RecordID==""){
        		$.messager.alert("提示","没有排队记录！","info");
        		return false;
    		}
    		var CallName=Arr[1];
    		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","DelayCurRoomInfo",RecordID)
    
    		var Arr=rtn.split("^");
    		if (Arr[0]!="0"){
        		 $.messager.alert("提示",alert(Arr[1]),"info");  
    		}
    		$("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 
    	} else {
       	 return false;
    	}
    })  
    
}

//过号
function Pass()
{
    var HospID=session['LOGON.HOSPID'];
    $.messager.confirm("提示", "确认要过号吗?", function (r) {
    if (r) {
    	var Info=GetNextInfo();
    	var Arr=Info.split("^");
   	 	var RecordID=Arr[0];
    	if (RecordID==""){
        	$.messager.alert("提示","没有排队记录！","info");
        	return false;
    	}
    
    	var CallName=Arr[1];
    
    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PassCurRoomInfo",RecordID)
    	var Arr=rtn.split("^");
    	if (Arr[0]!="0"){
        	$.messager.alert("提示",Arr[1],"info");
    	}
    	vRoomRecordID="";
    	$("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 
    } else {
          return false;
    }
    });

    
}

//科室确认
function BComplete()
{

	var HospID=session['LOGON.HOSPID'];
	var HospID=session['LOGON.HOSPID'];
   
	var RecordID="";
    
    var RoomID=$("#RoomID").val();
    if (RoomID=="") 
    {
	    $.messager.alert("提示","该诊室未启用排队叫号！","info");
        return false;
    }
    
    var PAADM=$("#PAADM").val();
    if (PAADM==""){
        $.messager.alert("提示","没有就诊记录!","info");
        return false;
    }
    
    var ret=tkMakeServerCall("web.DHCPE.RoomManager","CompleteCurRoom",RecordID,PAADM,RoomID)
    var Arr=ret.split("^");
    
    vRoomRecordID="";
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

    var WaitInfo=tkMakeServerCall("web.DHCPE.RoomManager","GetWaitInfo",PAADM)
    $("#WaitInfo").value(WaitInfo);
}


//过号启用
function ReStartPass(RecordID)
{
    var HospID=session['LOGON.HOSPID'];
    if (RecordID==""){
        $.messager.alert("提示","没有排队记录！","info");
        return false;
    }
    
    $.messager.confirm("提示", "确认要过号启用吗?", function (r) {
    if (r) {
        
   		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReStartCurRoomInfo",RecordID)
    
    	var Arr=rtn.split("^");
    	if (Arr[0]!="0"){
	    	$.messager.alert("提示",alert(Arr[1]),"info");
    	}
    	$("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

     } else {
     	return false;
    	 }
    });

    
 }
 
    
/// 病人信息列表  卡片样式
function setCellLabel(value, rowData, rowIndex){
        var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.Name
         +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.Sex +'/'+ rowData.Age 
         +'</span></h3><br>'+'<h3 style="float:left;background-color:transparent;"><span>'+ rowData.AdmDate
         +'</span></h3>';
         
        
        if((rowData.Status=="NE")||(rowData.Status=="N")){
            
        if(rowData.DetailStatus=="E"){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '正检'
                    +'</span></h3>';
            
                }
                
        if(rowData.DetailStatus=="C"){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '呼叫'
                    +'</span></h3>';
            
                }       
        if(rowData.DetailStatus==""){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '等待'
                    +'</span></h3>';
            
                }   
        }       
                
        if(rowData.Status=="P"){
                    htmlstr = htmlstr + '<h3><a><img style="float:right;background-color:transparent;" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_order.png"  title="过号启用" border="0" onclick="ReStartPass('+rowData.RecordID+')"></a></h3>';
            
                }
        
        htmlstr = htmlstr + '<br> <h4 style="float:left;background-color:transparent;">ID:'+ rowData.PAPMINo +'</h4>';
        var classstyle="color: #18bc9c";
        if(rowData.VIPLevel!=""){
            if(rowData.VIPLevel==3) {classstyle="color: #f9bf3b"};
            if(rowData.VIPLevel==1) {classstyle="color: #3c78d8"};
            if(rowData.VIPLevel==2) {classstyle="color: #f22613"};
            htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.VIPDesc+'</span></h4>';
        }
        htmlstr = htmlstr +'</div>';
        return htmlstr;
 }
 
function CallRegNoOnChange()
{
    var CTLocID=session['LOGON.CTLOCID'];
    var HospID=session['LOGON.HOSPID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo= $("#CallRegNo").val();
    if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
    	iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
        $("#CallRegNo").val(iRegNo);
    }
    
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:$("#CallRegNo").val(),RoomID:$("#RoomID").val(),HospID:HospID}); 
   
}
  
function CallQuery()
{
    var HospID=session['LOGON.HOSPID']
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:$("#CallRegNo").val(),RoomID:$("#RoomID").val(),HospID:HospID}); 
}


   
//撤销条码号关联
function BCancelPlacerNo_Click(){
	
	// 获取第一个选中的行
	var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
	if(selectrow==null)
	{
		$.messager.alert("提示","请选择待撤销预制号的医嘱",'info');
		return false;
	}
	if(selectrow.TSpecNo==""){
		$.messager.alert("提示","标本号为空,不能撤销预制号",'info');
		return false;
	}
	if(selectrow.TOSTATDesc!="核实"){
		$.messager.alert("提示","医嘱不是核实状态,不能撤销预制号",'info');
		return false;
	}
	if(selectrow.TPlacesNo==""){
		$.messager.alert("提示","预制号为空,不能撤销预制号",'info');
		return false;
	}

	//获取选中行的index
	var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
	if (selectrow.TOEORIRowId!=""){
			var	Strings=selectrow.TOEORIRowId+";"+selectrow.TPlacesNo+";"+selectrow.TSpecNo; 
		}
	
	var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"Y");
	
	if(flag!=0){
		$.messager.alert("提示",flag,'info');
		return false;
	}else{
		$.messager.alert("提示","撤销预制号成功",'success');
		$("#PlacerNo").val("");
		$('#SaveCollectSpecGrid').datagrid("updateRow",{
			index:selectindex ,
			row: {
				TPlacesNo:"",
			}
		});
 		
		return false;
	}
		
}

function Save_Click() {
	$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex); //最后一行结束行编辑	
	$("#SaveCollectSpecGrid").datagrid('reload');

}


function BSave_Click() {
	var vStatus = "",
		vDetailStatus = "",
		ReturnValue = "";

	var SpecNo = $("#SpecNo").val();
	if (SpecNo == "") {
		$.messager.popover({
			msg: "标本号不能为空",
			type: "info"
		});
		return false;
	}

	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", SpecNo);
	//alert(Value)
	var Arr = Value.split("^");
	var RegNoFlag = Arr[3];
	if (RegNoFlag == "1") {
		var PIADM = tkMakeServerCall("web.DHCPE.PreIADM", "GetPIADMByRegNo", SpecNo);
		if (PIADM == "") {
			return false
		}
		var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByRegNo", SpecNo);
		if (Status == "REGISTERED") {
			$.messager.confirm("确认", "确定要到达吗？", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByRegNo", SpecNo);
							if(Status!="ARRIVED"){
								$.messager.alert("提示", "到达失败", "error");
							}
							
						}
					});
				}
			});
		}

		$("#SpecNo").val("");
		$("#RegNo").val(SpecNo);
		$("#PAADM").val(Arr[2]);

	} else {
		$("#RegNo").val("");
		var PAADM = Arr[2];
		$("#PAADM").val(Arr[2]);
		var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
		var AdmArr = Status.split("^");
		var PIADM = AdmArr[1];
		//alert(Status)
		if (PIADM == "") {
			return false
		}
		if (AdmArr[0] == "REGISTERED") {
			$.messager.confirm("确认", "确定要到达吗？", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
							if(Status.split("^")[0]!="ARRIVED"){
								$.messager.alert("提示", "到达失败", "error");
							}
						}
					});
				}
			});

		}
	}

	if (Arr[0] == "0") {
		//$.messager.alert('提示', Arr[1], "info");
		$.messager.popover({msg: Arr[1],type: "info"});
		return false;
	} else if (Arr[0] == "1") {

		$.messager.confirm("确认", "该标本体检者不是当天到达,是否继续标本核对?", function(r) {
			if (r) {
				var RoomID = $("#RoomID").val();
				if (RoomID != "") {

					var CurRoomID = Value.split("^")[1];
					vStatus = Value.split("^")[4];
					vDetailStatus = Value.split("^")[5];
					if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
					{
						if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

					} else if (vRoomRecordID == "") {
						if (!confirm("没有叫号,是否继续?")) return false;
					}
				}
				//parent.vRoomRecordID="";
				vRoomRecordID = CurRoomID;
				if (vStatus == "N") { //判断是不是同一个人
					if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
						var UserID = session['LOGON.USERID'];
						var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

					}
				}

				Init();
				Find();
				BPrint_Click();

			}
		});

		//if (!(confirm("该标本体检者不是当天到达,是否继续标本核对?"))) {  return false; }
	} else {


		var RoomID = $("#RoomID").val();
		if (RoomID != "") {

			var CurRoomID = Value.split("^")[1];
			vStatus = Value.split("^")[4];
			vDetailStatus = Value.split("^")[5];
			if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
			{
				if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

			} else if (vRoomRecordID == "") {
				if (!confirm("没有叫号,是否继续?")) return false;
			}
		}
		//parent.vRoomRecordID="";
		vRoomRecordID = CurRoomID;
		if (vStatus == "N") { //判断是不是同一个人
			if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
				var UserID = session['LOGON.USERID'];
				var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

			}
		}

		Init();
		Find();
		BPrint_Click();
	}
}

function Init() {
	
	var HospID=session['LOGON.HOSPID'];
	var CTLocID=session['LOGON.CTLOCID'];
	
	var SpecNo = $("#SpecNo").val();
	var RegNo = $("#RegNo").val();
	if ((SpecNo == "") && (RegNo == "")) return false;
	var Str = tkMakeServerCall("web.DHCPE.BarPrint", "GetBaseInfo", RegNo, SpecNo,HospID,CTLocID)
	Str = Str.split("^");
	$("#Name").val(Str[0]);
	$("#Sex").val(Str[1]);
	$("#CardID").val(Str[2]);
	$("#RegNo").val(Str[3]);

	var ret = tkMakeServerCall("web.DHCPE.BarPrint", "GetSaveSpecInfo", $("#SpecNo").val(), $("#RoomRecordID").val(), $("#RoomID").val(), $("#PAADM").val(),SpecNoType)
	$("#CheckInfo").val(ret);


}



function Find() {

	var PAADM = $("#PAADM").val();
	var SpecNo = $("#SpecNo").val();
	var RegNo = $("#RegNo").val();
	if ((vRoomRecordID == "") && (SpecNo == "") && (PAADM == "")) {
		$.messager.alert('提示', '当前就诊者和标本号不能都为空', "info");
		return false;
	}
	var RoomID = $("#RoomID").val();
	if (RoomID == "") {
		vRoomRecordID = "";

	}
   
	$("#SaveCollectSpecGrid").datagrid('load', {
		ClassName: "web.DHCPE.BarPrint",
		QueryName: "FindOItemStatusForSpecNo",
		SpecNo: $.trim($("#SpecNo").val()),
		RoomRecordID: $("#RoomRecordID").val(),
		RoomID: $("#RoomID").val(),
		PAADM: $("#PAADM").val(),
		RegNo: $("#RegNo").val(),
		HospID:session['LOGON.HOSPID'],
		SpecNoType:SpecNoType,
		SessionStr:SessionStr
	})

}


//全部取消
function BSARef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "启用") {
			RefuseApp(ID)
		}
	}

}

//全部启用
function BSRRef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "取消") {
			RefuseApp(ID)
		}
	}
}


function RefuseApp(ID) {

	var ret = tkMakeServerCall("web.DHCPE.BarPrint", "RefuseItemBySpecNo",ID,SessionStr);
	if (ret == "0") {
		$("#SaveCollectSpecGrid").datagrid('load', {
			ClassName: "web.DHCPE.BarPrint",
			QueryName: "FindOItemStatusForSpecNo",
			SpecNo: $.trim($("#SpecNo").val()),
			RoomRecordID: $("#RoomRecordID").val(),
			RoomID: $("#RoomID").val(),
			PAADM: $("#PAADM").val(),
			RegNo: $("#RegNo").val(),
			HospID:session['LOGON.HOSPID'],
			SpecNoType:SpecNoType,
			SessionStr:SessionStr
		})
	}
}

//打开软键盘
function ShowSoftKey_click() {
	//var shell = new ActiveXObject("wscript.shell")
	//shell.run("osk.exe");
	location.replace("tabkey:");
	return false;
}

//打印
function BPrint_Click() {
	
	if(SpecNoType=="" ){
		SpecNoType="血";
	}
	
	//BloodFlag:2 血,1 非血,空 所有标本类型
	var BloodFlag="";
	if(SpecNoType.indexOf("血")>-1){
		var BloodFlag="2"; 
	}else if((SpecNoType.indexOf("尿")>-1)||(SpecNoType.indexOf("便")>-1)){
		var BloodFlag="1";
	}else{
		var BloodFlag="";
	}

	//var PAADM = "";
	var PAADM = $("#PAADM").val();
	var PrintBarFlag = 0;
	var PrintBarCode = $("#PrintBarCode").checkbox('getValue');
	if (PrintBarCode) { var PrintBarFlag = 1;}
    if (PrintBarFlag!==1) return ;
    
 	var RegNo = $("#RegNo").val();   
	var SpecNo = $("#SpecNo").val();
	var LocID=session['LOGON.CTLOCID'];
	var SpecOneFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"CollectSpecOne");

/*
	if (SpecNo==""){ var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", RegNo);}
	else {var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", SpecNo);}
	var Arr = Value.split("^");
	var PAADM = Arr[2];
*/
   if (RegNo==""){
		$.messager.alert("提示", "标本号不能为空", "info");
		return false;
	}else{
		if (SpecNo!==""){
			if (SpecOneFlag=="Y"){
				PrintAllApp(SpecNo, "Spec", "N","",BloodFlag)
			}else{
				PrintAllApp(PAADM, "PAADM", "N","",BloodFlag)
			}
			
		}else{
			PrintAllApp(PAADM, "PAADM", "N","",BloodFlag)
		}
	}
  
}

function InitSaveCollectSpecGrid() {
	$HUI.datagrid("#SaveCollectSpecGrid", {
		url: $URL,
		fit: true,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.BarPrint",
			QueryName: "FindOItemStatusForSpecNo",
			SpecNoType:SpecNoType,
			SessionStr:SessionStr
		},
		onClickRow: onClickRow,
		onAfterEdit: function(index, row, changes) {
			
		//$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex); //最后一行结束行编辑 
			modifyAfterRow = $('#SaveCollectSpecGrid').datagrid('getRows')[index]['TRefuse'] 
			//alert(modifyBeforeRow+"^"+modifyAfterRow)
			if(modifyBeforeRow!=modifyAfterRow){
				$.messager.confirm('确定', '确定要保存数据吗？', function(t) {
				if (t) { 
					var ret=tkMakeServerCall("web.DHCPE.BarPrint","RefuseItemBySpecNo",row.TSpecNo,SessionStr);
					if(ret=="0"){
						$("#SaveCollectSpecGrid").datagrid('load',{
							ClassName:"web.DHCPE.BarPrint",
							QueryName:"FindOItemStatusForSpecNo",
							SpecNo:$.trim($("#SpecNo").val()),
							RoomRecordID:$("#RoomRecordID").val(),
							RoomID:$("#RoomID").val(),
							PAADM:$("#PAADM").val(),
							RegNo:$("#RegNo").val(),
							SpecNoType:SpecNoType,
							SessionStr:SessionStr
						})
					}
				}
			})
		
			}


		},
		onLoadSuccess: function(data) {
			editIndex = undefined;
		},
		columns: [
			[

				{
					field: 'TOEORIRowId',
					title: 'OEORIRowId',
					hidden: true
				}, {
					field: 'TOEORIItmMastDR',
					title: 'ItmMastDR',
					hidden: true
				}, {
					field: 'TAdmId',
					title: 'PAADM',
					hidden: true
				}, {
					field: 'TPlacerColor',
					width: '100',
					title: '容器颜色',
					styler: function(value, row, index) {
						return 'background-color:' + row.TPlacerColor;
					}

				}, {
					field: 'TPlacerCode',
					width: '100',
					title: '容器名称'
				}, {
					field: 'TItemName',
					width: '200',
					title: '医嘱'
					
				}, {
					field: 'TSpecName',
					width: '100',
					title: '标本名称'
				}, {
					field: 'TSpecNo',
					width: '150',
					title: '标本号'
				}, {
					field: 'TRegNo',
					width: '120',
					title: '登记号'
				}, {
					field: 'TName',
					width: '100',
					title: '姓名'
				}, {
					field: 'TDate',
					width: '100',
					title: '日期'
				}, {
					field: 'TTime',
					width: '100',
					title: '时间'
				}, {
					field: 'TUserName',
					width: '80',
					title: '采集人'
				}, {
					field: 'TOSTATDesc',
					width: '80',
					title: '医嘱状态'
				},{
					field: 'TRefuse',
					width: '80',
					title: '状态',
					editor: {
						type: 'switchbox',
						options: {
							onClass: 'primary',
							offClass: 'gray',
							onText: '启用',
							offText: '取消'
						}
					}
				}, {
					field: 'TPlacesNo',
					width: '60',
					title: '预制号'
				},{

					field: 'TSex',
					width: '60',
					title: '性别'
				}, {
					field: 'TAge',
					width: '60',
					title: '年龄'
				}


			]
		],

		rowStyler: function(index, row) {

			if (row.TOSTATDesc == "谢绝检查") {
				return 'background-color:#fff3dd;';
			}



		},
		onSelect: function(rowIndex, rowData) {


		}


	})

}




//列表编辑
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//结束行编辑
function endEditing() {

	if (editIndex == undefined) {
		return true
	}
	if ($('#SaveCollectSpecGrid').datagrid('validateRow', editIndex)) {

		$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex);



		editIndex = undefined;
		return true;
	} else {
		return false;
	}

}

//点击某行进行编辑
function onClickRow(index, value) {
	if (editIndex != index) {
		if (endEditing()) {
			$('#SaveCollectSpecGrid').datagrid('selectRow', index)
				.datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $('#SaveCollectSpecGrid').datagrid('getRows')[index]['TRefuse']

		} else {
			$('#SaveCollectSpecGrid').datagrid('selectRow', editIndex);
		}


	}

}



function SpecNo_Click() {
	var vStatus = "",
		vDetailStatus = "",
		ReturnValue = "";

	var SpecNo = $("#SpecNo").val();
	if (SpecNo == "") {
		$.messager.popover({
			msg: "标本号不能为空",
			type: "info"
		});
		return false;
	}
     //判断输入的标本号是不是包含在该采集界面维护的类型中
    var Flag=tkMakeServerCall("web.DHCPE.BarPrint", "IsCanSaveSpec",SpecNo,SpecNoType);
    if(Flag=="0"){
	    $.messager.popover({
			msg: "输入的标本号不在该界面采集，请核实！",
			type: "info"
		});
		return false;
	    
    }else{
	    if (Flag!="1"){
		     $.messager.popover({
				msg: Flag,
				type: "info"
			});
			return false;
		    
	    }
	    
    }


	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDateBySpecNo", SpecNo);
	//alert(Value)
	var Arr = Value.split("^"); 
		var PAADM = Arr[2];
		$("#PAADM").val(Arr[2]);
		GetSaveCollectByPAADM(PAADM); 
		
}



function RegNo_Click()
{
	var CTLocID=session['LOGON.CTLOCID'];
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo,
			"CTLocID":CTLocID
		}, false);
		
			$("#RegNo").val(iRegNo)
		} 
		if (iRegNo=="") 
	   {
			$.messager.popover({msg: "请输入登记号", type: "info"});
		   return false;
	   }
	   
		var PAADMS=tkMakeServerCall("web.DHCPE.BarPrint","GetSaveCollectRecord",iRegNo);
		//alert(PAADMS)
		if (PAADMS.split("^")[0]!="0"){
			//alert(PADMS.split("^")[1]);
			$.messager.popover({msg: PAADMS.split("^")[1], type: "info"});
			return false;
		}
		var PAADM=PAADMS.split("^")[1];
		if (PAADM==""){
			$.messager.popover({msg: "没有要采集标本的记录", type: "info"});
			return false;
			}
		var PAADMArr=PAADM.split("$");
		
		if (PAADMArr.length>2){
           openPAADMRecord(iRegNo)
   
		}else{
			GetSaveCollectByPAADM(PAADMArr[0]);
			
	}
		
}


var openPAADMRecord= function(RegNo){
    
    $("#PAADMRecordWin").show();
    
    $HUI.window("#PAADMRecordWin",{
        title:'就诊列表',
        minimizable:false,
        collapsible:false,
        modal:true,
        width:930,
        height:400
    });
    
    var PAADMLisObj = $HUI.datagrid("#PAADMRecordList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.BarPrint",
            QueryName:"FindPAADMInfo",
            RegNo:RegNo, 
			HospID:session['LOGON.HOSPID']
        },
        columns:[[
        	{field:'PAADM',title:'PAADM',hidden:true},
            {field:'Name',width:120,title:'姓名'},
            {field:'RegNo',width:120,title:'登记号'},
            {field:'HPNo',width:120,title:'体检编号'},
            {field:'AdmDate',width:100,title:'日期'},
            {field:'StatusDesc',width:100,title:'状态'},
            {field:'GName',width:200,title:'团体名称'},
            {field:'TeamName',width:120,title:'分组名称'},
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onDblClickRow: function(rowIndex,rowData){
	          $("#SpecNo").val("");
	           GetSaveCollectByPAADM(rowData.PAADM);
	 
  				}
        
        })
    
}


function GetSaveCollectByPAADM(PAADM){
		var vStatus = "",vDetailStatus = "",ReturnValue = "";
		$("#PAADM").val(PAADM);
			var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
			var AdmArr = Status.split("^");
			var PIADM = AdmArr[1];
			//alert(Status)
		if (PIADM == "") {
				return false;
			}
		if (AdmArr[0] == "REGISTERED") {
			$.messager.confirm("确认", "确定要到达吗？", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
							if(Status.split("^")[0]!="ARRIVED"){
								$.messager.alert("提示", "到达失败", "error");
								return false;
							}
						}else{
							SaveCollectByPAADM(PAADM);		
						}
					});
				}
			});

	}else{
		SaveCollectByPAADM(PAADM);
	}
}


function SaveCollectByPAADM(PAADM)
{	
	var vStatus = "",vDetailStatus = "",ReturnValue = "";
	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDateByPAADM", PAADM);
	//alert(Value)
	var Arr = Value.split("^");
	if (Arr[0] == "0") {
		$.messager.popover({msg: Arr[1],type: "info"});
		return false;
	} else if (Arr[0] == "1") {

		$.messager.confirm("确认", "该标本体检者不是当天到达,是否继续标本核对?", function(r) {
			if (r) {
				var RoomID = $("#RoomID").val();
				if (RoomID != "") {

					var CurRoomID = Value.split("^")[1];
					vStatus = Value.split("^")[4];
					vDetailStatus = Value.split("^")[5];
					if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
					{
						if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

					} else if (vRoomRecordID == "") {
						if (!confirm("没有叫号,是否继续?")) return false;
					}
				}
				//parent.vRoomRecordID="";
				vRoomRecordID = CurRoomID;
				if (vStatus == "N") { //判断是不是同一个人
					if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
						var UserID = session['LOGON.USERID'];
						var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

					}
				}
                
				Init();
				Find();
				BPrint_Click();

			}
		});

		
	} else {

		var RoomID = $("#RoomID").val();
		if (RoomID != "") {
			var CurRoomID = Value.split("^")[1];
			vStatus = Value.split("^")[4];
			vDetailStatus = Value.split("^")[5];
			if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
			{
				if (!confirm("到达者和叫号者不是同一个人,是否继续?")) return false;

			} else if (vRoomRecordID == "") {
				if (!confirm("没有叫号,是否继续?")) return false;
			}
		}
		//parent.vRoomRecordID="";
		vRoomRecordID = CurRoomID;
		if (vStatus == "N") { //判断是不是同一个人
			if (vDetailStatus != "E") { //不是正检状态的，设置正检，下屏
				var UserID = session['LOGON.USERID'];
				var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

			}
		}

		Init();
		Find();
		BPrint_Click();
	}
	
}
