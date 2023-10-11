﻿$(function(){
	if(typeof HISUIStyleCode=='string' && HISUIStyleCode=='blue'){
				
				document.body.style.background="#FFFFFF";
			}
	var SelectedRowID = 0;
	var preRowID=0; //定义全局变量,判断该行是否选中
	var myDate = new Date();
    var defaultDate = myDate.format("dd/MM/yyyy");
    $("#StartDateTime").datebox("setValue",defaultDate);
    $("#EndDateTime").datebox("setValue",defaultDate);
    var groupId=session['LOGON.GROUPID']
    var ifAllLoc="N"
    $("#Bed").combogrid({
            panelWidth: 150,
            loadMsg: "正在加载中...",
            width: 140,
            rownumbers: true,
            idField: "Id",
            textField: "Code",
            url: 'dhcclinic.jquery.csp',
            queryParams: {
                ClassName: "web.DHCICUBedDevice",
                QueryName: "FindICUBed",
                Arg1: session['LOGON.CTLOCID'],
                Arg2: function () {
                    return $("#Bed").combogrid("getText");
                },

                ArgCnt: 2
            },
            columns: [[
                { field: "Id", title: "ID" },
                { field: "Code", title: "Desc" }
            ]]
      , onShowPanel: function () { $(this).combogrid('grid').datagrid('reload'); }
      , onChange: function () {
          if ($(this).nextAll().find("input").is(":focus"))
              $(this).combogrid('grid').datagrid('reload');
      }
      ,onHidePanel: function () {
	      //20190110 YuanLin 下拉框只能选择不允许手写
	      var SelectRow = $(this).combogrid("grid").datagrid('getSelected');
	      var Val = $(this).combogrid('getValue');
	      if(SelectRow)
	      {
		      if (Val != SelectRow.Id)
		      {
			      $.messager.alert("提示","请从下拉框选择","info");
			      return;
			  }
		  }
        }
       });
    //允许非重症科室查看重症列表(住院护士 住院护士长 住院医师 住院医师主任) YuanLin 20191107
    if((groupId==23)||(groupId==25)||(groupId==29)||(groupId==30)) ifAllLoc="Y"
	var ICUArrangeConfigObj=$HUI.datagrid("#ICUArrangeConfig",{
		singleSelect: true,
        fitColumns:false,
        fit:true,
        rownumbers: true,
        headerCls:'panel-header-gray',
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
		queryParams:{
			ClassName:"web.DHCICUArrange",
			QueryName:"FindICUArrangeNew",
            ArgCnt: 8
		},
		onBeforeLoad:function(param){
			param.fromDate="",
			param.toDate="",
			param.bedId=$("#Bed").datebox("getValue"),
			param.regNo=$("#RegNo").val(),
			param.ctlocId=session['LOGON.CTLOCID'],
			param.papmiMedicare=$("#MedicalNo").val(),
			param.papmiName=$("#PatName").val(),
			param.ifAllLoc=ifAllLoc
		},
        columns:[[
            { field:"operator" ,title: "操作", width: 50 ,align:'center',
				formatter:function(value, row, index){
					
					var str = '<a href="#" name="监护" onclick="onClickRowButton(\''+row.icuaId+'\')" class="easyui-linkbutton" >监护</a>';
					return str;
				}},
			{ field: "tStartDateTime", title: "开始日期", width: 120, sortable: true},
            { field: "leaveDateTime", title: "转归日期", width: 120, sortable: true },
            { field: "statusDesc", title: "病人状态", width: 80, align:'center',
				styler: function(value,row,index){
				if (value=="安排"){
		        return 'background-color:#47CE27;color:#ffffff;text-align:center';}
		        if (value=="监护"){
			    return 'background-color:#F17AE9;color:#ffffff;text-align:center';}
			    if (value=="停止"){
				return 'background-color:#00CAF3;color:#ffffff;text-align:center';} // palegreen  magenta lightblue
				}
			},
            { field: "tRegNo", title: "登记号", width: 100, sortable: true },
			{ field: "tPatName", title: "病人姓名", width: 120, sortable: true },
			{ field: "tBedCode", title: "病人床位", width: 120, sortable: true ,
			sorter:function(a,b){
				if(a>b){
					return (a>b?1:-1);
					}}},
            { field: "tWardDesc", title: "病区", width: 200, sortable: true },
			{ field: "icuaId", title: "重症记录ID", width: 120, sortable: true },
            { field: "tEpisodeID", title: "就诊号", width: 100, sortable: true },
            { field: "tPatHeight", title: "身高", width: 80, sortable: true },
			{ field: "tPatWeight", title: "体重", width: 80, sortable: true },
            { field: "tMedCareNo", title: "病案号", width: 100, sortable: true },
			{ field: "tBodySquare", title: "身体表面积", width: 120, sortable: true },
            { field: "tICUAAttendingCtcpDesc", title: "主治医师", width: 120, sortable: true },
            { field: "tICUAResidentCtcpDesc", title: "住院医师", width: 120, sortable: true },
			{ field: "mainNurse", title: "主管护士", width: 120, sortable: true },
            { field: "mainNurseTwo", title: "主管护士2", width: 120, sortable: true },
            { field: "patLeaveCon", title: "转归去向", width: 120, sortable: true},
			{ field: "limitedTreatment", title: "限制治疗", width: 120, sortable: true },
            { field: "apacheQty", title: "Apache评分", width: 100, sortable: true },
			{ field: "icuBedId", title: "床位ID", width: 100, sortable: true },
            { field: "curWardId", title: "病区ID", width: 100, sortable: true }
        ]],
		onClickRow:function(){
            var row=ICUArrangeConfigObj.getSelected();
            if(row)
            {  var frm = window.top.document.forms['fEPRMENU'];
        if (frm) {
	            frm.EpisodeID.value=row.tEpisodeID;
        }
		        SelectedRowID=row.Id;
		        if(preRowID!=SelectedRowID)
		        {
			        preRowID=SelectedRowID;
			        $("#PatName").val(row.tPatName);
			        $("#RegNo").val(row.tRegNo);
			        $("#Status").combobox("setText",row.statusDesc);
			        $("#MedicalNo").val(row.tMedCareNo);
			    }
		        else
		        {
			        SelectedRowID = 0;
			        preRowID=0;
			        ICUArrangeConfigObj.clearSelections();
			        $("#PatName").val("");
			        $("#RegNo").val("");
			        $("#Status").combobox("setText","");
			        $("#MedicalNo").val("");
		        }
	        }
        }
	})
    var Status = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
		     {id:'R',text:'安排'}
			,{id:'M',text:'监护'}
			,{id:'T',text:'停止'}
			,{id:'F',text:'完成'}	
		]
	})
	var btnSchObj=$HUI.linkbutton("#btnSearch",{
		onClick: function(){
			var param = {
			    ClassName:"web.DHCICUArrange",
			    QueryName:"FindICUArrangeNew",
			    fromDate:"",
		        toDate:"",
		        bedId:$("#Bed").datebox("getValue"),
		        regNo:$("#RegNo").val(),
		        ctlocId:session['LOGON.CTLOCID'],
		        papmiMedicare:$("#MedicalNo").val(),
		        papmiName:$("#PatName").val(),
		        WardType:"In",
			    ifAllLoc:ifAllLoc
			};
			ICUArrangeConfigObj.load(param);
			//$("#PatName").val("");
			//$("#Status").combobox("setValue","");
			//$("#RegNo").val("");
			//$("#MedicalNo").val("");
        }
	})
	var btnMonitorObj=$HUI.linkbutton("#btnMonitor",{
		onClick: function(){
			var row=ICUArrangeConfigObj.getSelected();
            if(row)
            {
	            var status=row.tStatus;
	            if ((status!="R")&&(status!="M")&&(status!="T")&&(status!="F"))
	            {
		            alert("Setlect record please!");
		            return;
		        }
		        var icuaId=row.icuaId;
		        var EpisodeID=row.tEpisodeID;
		        if ((icuaId=="")&&(EpisodeID=="")) return;
		        var frm = document.forms["fEPRMENU"];
		        var userCtlocId=session['LOGON.CTLOCID']
		        if ((icuaId=="")&&(EpisodeID=="")) return;
		        var curLocation=unescape(window.location);
		        curLocation=curLocation.toLowerCase();
		        var locationId=GetWardCtlocId(icuaId);
		        //中间件运行
				//var ServerNameSpace="cn_iptcp:114.242.246.243[1972]:DHC-APP" //临时测试用
			    var filePath = window.location.href.split("csp")[0] + "/service/dhcclinic/";
				var args = [icuaId, EpisodeID, session["LOGON.USERID"], session["LOGON.GROUPID"], locationId,ServerNameSpace,filePath,""]
			    //IntensiveCare.Show(icuaId,EpisodeID,session["LOGON.USERID"],session["LOGON.GROUPID"],userCtlocId,ServerNameSpace,filePath,"");
			    IntensiveCare.clear();
			    IntensiveCare.cmd('Main.exe'+' '+args)
		        //var curLocation=unescape(window.location);
		        //curLocation=curLocation.toLowerCase();
		        //var filePath=curLocation.substr(0,curLocation.indexOf('/csp/'))+"/service/DHCClinic/";
		        //var locationId=GetWardCtlocId(icuaId);
		        //var lnk="../service/dhcclinic/app/icu/Main.application?icuaId="+icuaId+"&userId="+session["LOGON.USERID"]+"&groupId="+session["LOGON.GROUPID"]+"&locId="+locationId+"&connString="+connString+"&filePath="+filePath+"&total=";
		        //window.open(lnk);
            }
            else
            {
	            alert("请选择一条监护记录!")
            }
        }
	})
	
    $("input[name='WardType'][value='Into']").checkbox({
	    onCheckChange: function(e, value) {
		    if (value === false) return;
            $("input[name='WardType'][value='In']").checkbox("setValue", false);
            $("input[name='WardType'][value='Out']").checkbox("setValue", false);
		}
	});
	$("input[name='WardType'][value='In']").checkbox({
	    onCheckChange: function(e, value) {
		    if (value === false) return;
            $("input[name='WardType'][value='Into']").checkbox("setValue", false);
            $("input[name='WardType'][value='Out']").checkbox("setValue", false);
		}
	});
	$("input[name='WardType'][value='Out']").checkbox({
	    onCheckChange: function(e, value) {
		    if (value === false) return;
            $("input[name='WardType'][value='Into']").checkbox("setValue", false);
            $("input[name='WardType'][value='In']").checkbox("setValue", false);
		}
	});
});
function onClickRowButton(icuaId)
{
    //var icuaId=row.icuaId;
    //var EpisodeID=row.tEpisodeID;
    if (icuaId=="") return;
    var frm = document.forms["fEPRMENU"];
    var userCtlocId=session['LOGON.CTLOCID']
    var curLocation=unescape(window.location);
    curLocation=curLocation.toLowerCase();
    var locationId=GetWardCtlocId(icuaId);
    //中间件运行
	//var ServerNameSpace="cn_iptcp:114.242.246.243[1972]:DHC-APP" //临时测试用
    var filePath = window.location.href.split("csp")[0] + "/service/dhcclinic/";
	var args = [icuaId, "", session["LOGON.USERID"], session["LOGON.GROUPID"], locationId,ServerNameSpace,filePath,""]
    IntensiveCare.clear();
    IntensiveCare.cmd('Main.exe'+' '+args)
}
function GetWardCtlocId(icuaId) {
		var result = null;
		$.ajax({
			url:$URL,
			async: false,
			data: {
				ClassName: "web.DHCICUCom",
				MethodName: "GetWardCtlocId",
				wardId:"",
				icuaId:icuaId,
				ArgCnt:2
			},
			type: "post",
			success: function(data) {
				result = data;
			}
		});
		return result;
    }
function RegSearch()
{
	if(window.event.keyCode==13)
	{
		var newregno=$.m({
			ClassName:"web.DHCDTHealthCommon",
			MethodName:"FormatPatientNo",
			PatientNo:$("#RegNo").val()
		},false);
		$("#RegNo").val(newregno);
		$HUI.datagrid("#ICUArrangeConfig").load();
	}
}