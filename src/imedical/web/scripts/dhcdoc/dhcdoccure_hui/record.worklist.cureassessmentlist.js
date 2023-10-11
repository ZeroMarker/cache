var workList_AssListObj=(function(){
	var CureAssessmentDataGrid;
	function InitCureAssessmentDataGrid()
	{
		var hiddenCol=(ServerObj.PageVersion=="WV2");
		if (ServerObj.PageShowFromWay=="ShowFromEmrList"){
			var cureToolBar="";
		}else{
			var cureToolBar = [{
				id:'BtnUpdate',
				text:'新增', 
				iconCls:'icon-add',  
				handler:function(){
					AddAssessment();
				}
			},{
				id:'BtnUpdate',
				text:'修改', 
				iconCls:'icon-write-order',  
				handler:function(){
					UpdateAssessment();
				}
			},{
				id:'BtnDelete',
				text:'删除', 
				iconCls:'icon-cancel',  
				handler:function(){
					DeleteAssessment();
				}
			}];
		}
		CureAssessmentDataGrid=$('#tabCureAssessmentList').datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : false,
			fitColumns : false,
			autoRowHeight : true,
			loadMsg : '加载中..',  
			pagination : true,
			rownumbers : true,
			idField:"DCAssRowId",
			pageSize : 10,
			pageList : [10,20,50],
			frozenColumns : [[
				{field:'RowCheck',checkbox:true},
				{field:'DCARowId',title:'',width:1,hidden:true}, 
				{field:'ApplyNo',title:'申请单号',width:110,align:'left', resizable: true, hidden:hiddenCol},  
				{field:'PatientName',title:'姓名',width:80,align:'left', resizable: true, hidden:hiddenCol},   
				{field:'PatOther',title:'患者其他信息',width:200,align:'left', resizable: true, hidden:hiddenCol},
				{field:'ArcimDesc',title:'治疗项目',width:200,align:'left', resizable: true}
			]],
			columns :[[
				{field:'DCAssDate',title:'评估时间',width:150},
				{field:'DCAssTempTitile',title:'评估模板',width:180},
				{field:'DCAssContent',title:'评估内容',width:350,
					formatter:function(value,row,index){
						if(row.DCAssRowId==""){
							return "<span class='fillspan'>"+$g("暂未评估")+"</span>";
						}else{
							return "<span class='fillspan-nosave'>"+$g("双击查看明细")+"</span>";
						}
					}
				},  
				{field:'DCAssUser',title:'创建人',width:90},
				{field:'DCAssLastUser',title:'最后更新人',width:90},
				{field:'DCAssLastDate',title:'最后更新时间',width:150},
				{field:'DCAssRowId',title:'DCAssRowId',width:50,hidden:true},
				{field:'DCAssAdmID',title:'DCAssAdmID',width:50,hidden:true},
				{field:'DCAssTempID',title:'DCAssTempID',width:50,hidden:true},
				{field:'ApplyStatus',title:'ApplyStatus',width:50,hidden:true},
				{field:'OrdBilled',title:'OrdBilled',width:50,hidden:true}
			 ]] ,
	    	toolbar : cureToolBar,
	    	onDblClickRow:function(rowIndex, rowData){ 
	    		if(rowData.DCAssRowId!=""){
					UpdateAssessment(rowData);
	    		}else if(ServerObj.PageShowFromWay!="ShowFromEmrList"){
		    		AddAssessment();
		    	}
	       	},
            onSelect:function(rowIndex, rowData){ 
                var DCAssRowId=rowData.DCAssRowId;
                var DCARowId=rowData.DCARowId;
                if (websys_getAppScreenIndex()==0){
                    if (DCAssRowId!=""){
                        var DCARowId=rowData.DCARowId;
                        var DCAssTempID=rowData.DCAssTempID;
                        var DCAssAdmID=rowData.DCAssAdmID;
                        var OperateType="";
                        var DCRowIDStr="";
                        if(DCAssTempID==""){
                            //若未获取到评估模板,则展示简化版的界面
                            var myhref="doccure.cureassessment.hui.csp?OperateType="+"&EpisodeID="+DCAssAdmID+"&DCARowId="+DCARowId+"&DCAssRowId="+DCAssRowId+"&DCRowIdStr="+DCRowIDStr+"&PageShowFromWay="+ServerObj.PageShowFromWay;
                        }else{
                            var myhref="doccure.asstemp.hui.csp?DCARowId="+DCARowId+"&DCAssRowId="+DCAssRowId+"&OperateType=&DCRowIDStr="+DCRowIDStr+"&DCAssTempID="+DCAssTempID+"&DCAdmID="+DCAssAdmID+"&PageShowFromWay="+ServerObj.PageShowFromWay;
                        }
                        var frameurl=myhref.replace(/&/g,"!@")
                        websys_emit("onOpenDHCDoc",{title:"治疗评估",frameurl:frameurl});
                    }else if (DCARowId!=""){
                        // 展示患者治疗申请信息
                        var Obj={DCARowId:DCARowId,EpisodeID:rowData.DCAssAdmID};
                        websys_emit("onOpenCureAppInfo",Obj);
                        return;
                    }
                }
            }
		});
	}
	function CureAssessmentDataGridLoad()
	{
		var DCARowIDArr=GetDCARowIDArr();
		if(DCARowIDArr.length==0){
			CureAssessmentDataGrid.datagrid("clearSelections").datagrid('loadData',{total:0,rows:[]});
			return;
		}
		var DCARowIdStr=DCARowIDArr.join("^");
		if(CureAssessmentDataGrid){
			CureAssessmentDataGrid.datagrid({
				url:$URL,
				queryParams:{
					ClassName:"DHCDoc.DHCDocCure.Assessment",
					QueryName:"FindCureAssessmentList",
					'DCARowIdStr':DCARowIdStr
				}	
			})
			CureAssessmentDataGrid.datagrid("clearSelections")
		}
	}

	function GetDCARowIDArr(){
		var Ids=[];
		var DCAARowIdStr="";
		if(typeof(PageAppListAllObj)!="undefined"){
			//改为页签形式，id由PageAppListAllObj获取
			DCAARowIdStr=PageAppListAllObj._SELECT_DCAROWID;
		}else if(typeof(PageWorkListAllObj)!="undefined"){
			//治疗工作平台治疗评估
			DCAARowIdStr=PageWorkListAllObj._WORK_SELECT_DCAROWID;	
		}else{
			DCAARowIdStr=ServerObj.DCARowIdStr;
		}
		if(DCAARowIdStr==""){
			return Ids;	
		}
		var DCAARowIdArr=DCAARowIdStr.split("!");
		var StrLen=DCAARowIdArr.length;
		for(var i=0;i<StrLen;i++){
			var DCAARowId=DCAARowIdArr[i];
			var	DCARowId=DCAARowId.split("||")[0];
			if(Ids.indexOf(DCARowId)<0){
				Ids.push(DCARowId);
			}
		}
		return Ids;
	}
	
	
	function OpenCureAssDiagBatch(RowIDStr,callBack){
		var jsonStr=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Assessment",
			MethodName:"GetAssAdmInfo",
			dataType:"text",
			RowIDs:RowIDStr
		},false);
		if(jsonStr!=""){
			var obj=JSON.parse(jsonStr); 
			var Len=obj.List.length;
			if(Len>0){
				function Loop(j){
					new Promise(function(resolve,rejected){
						var oneObj=obj.List[j];
						var AssAdmID=oneObj.AssAdmID;
						var RowIDStr=oneObj.RowIDStr;
						OpenThisAssDiag(oneObj,resolve);
					}).then(function(value){
						callBack()
						j++;
						if ( j < Len ) {
							 Loop(j);
						}else{
							
						}
					})
				}
				Loop(0);
			}	
		}
	}
	function OpenThisAssDiag(AssTempObj,callBack)
	{
		if(typeof AssTempObj != "object"){
			$.messager.alert("提示","获取必要参数错误", 'error');
			return	
		}
		var myAssTempObj={
			DCARowId:"",
			RowIDStr:"",
			AssAdmID:""
		}
		$.extend(myAssTempObj,AssTempObj)
		var myhref="";
		var DCARowId=myAssTempObj.DCARowId;
		var DCRowIDStr=myAssTempObj.RowIDStr;
		var AssAdmID=myAssTempObj.AssAdmID;
		if(typeof ServerObj.PageShowFromWay=='undefined')ServerObj.PageShowFromWay="";
		myhref="doccure.asstemp.main.hui.csp?DCARowId="+DCARowId+"&DCRowIDStr="+DCRowIDStr+"&DCAdmID="+AssAdmID+"&PageShowFromWay="+ServerObj.PageShowFromWay;
		if(myhref!=""){
			OpenCureDiag(myhref,callBack,'90%','95%')
		}else{
			$.messager.alert("提示","获取打开评估链接错误", 'error');
		}
	}
	
	function OpenCureAssDiag(AssTempObj,callBack)
	{
		if(typeof AssTempObj != "object"){
			$.messager.alert("提示","获取必要参数错误", 'error');
			return	
		}
		var myAssTempObj={
			DCARowId:"",
			DCAssRowId:"",
			AssTempID:"",
			RowIDStr:"",
			AssAdmID:""
		}
		$.extend(myAssTempObj,AssTempObj)
		var myhref="";
		var DCARowId=myAssTempObj.DCARowId;
		var DCAssRowId=myAssTempObj.DCAssRowId;
		var AssTempID=myAssTempObj.AssTempID;
		var DCRowIDStr=myAssTempObj.RowIDStr;
		var AssAdmID=myAssTempObj.AssAdmID;
		
		if(AssTempID==""){
			//若未获取到评估模板,则展示简化版的界面
			var diagH="600px";
			var diagW="880px";
			myhref="doccure.cureassessment.hui.csp?OperateType="+"&EpisodeID="+AssAdmID+"&DCARowId="+DCARowId+"&DCAccRowId="+DCAssRowId+"&DCRowIdStr="+DCRowIDStr+"&PageShowFromWay="+ServerObj.PageShowFromWay;
		}else{
			var diagH="700px";
			var diagW="1200px"
			myhref="doccure.asstemp.hui.csp";
			var DHCDocCureAssLinkPage=ServerObj.DHCDocCureAssLinkPage;
			if(DHCDocCureAssLinkPage.indexOf(".csp")>-1){
				var arr=DHCDocCureAssLinkPage.split("&");
				myhref=arr[0];
				if(arr.length>1){
					diagW=arr[1].split("=")[1];
				}
				if(arr.length>2){
					diagH=parseInt(arr[2].split("=")[1]);
				}
			}
			myhref=myhref+"?DCARowId="+DCARowId+"&DCAssRowId="+DCAssRowId+"&OperateType="+$('#OperateType').val()+"&DCRowIDStr="+DCRowIDStr+"&DCAssTempID="+AssTempID+"&DCAdmID="+AssAdmID+"&PageShowFromWay="+ServerObj.PageShowFromWay;
		}
		if(myhref!=""){
			OpenCureDiag(myhref,callBack,diagH,diagW)
		}else{
			$.messager.alert("提示","获取打开评估链接错误", 'error');
		}
	}
	
	function OpenCureDiag(href,callBack,diagH,diagW){
		var diagW=diagW||"1200px";
		var diagH=diagH||"900px";
		websys_showModal({
			url:href,
			iconCls:"icon-w-paper",
			title:'治疗评估记录',
			width:diagW,height:diagH,
			onClose: function() {
				callBack();
			}
		});
	}
	
	/*
		新增治疗评估记录
		治疗预约界面评估-获取可评估的申请单ID信息
		治疗处理界面评估-根据选择的治疗预约信息得到申请单ID信息
	*/
	function AddAssessment(){
		var RowIdArr=new Array();
		if(typeof(CureApplyDataGrid)=="object"){
			var rows = CureApplyDataGrid.datagrid("getSelections");
			if (rows.length==0) 
			{
				$.messager.alert("提示","请选择一个申请单","warning");
				return false;
			}
			var DCARowIdStr=""
			for(var i=0;i<rows.length;i++){
				var DCARowIds=rows[i].DCARowId;
				var OrdBilled=rows[i].OrdBilled;
				var ApplyExec=rows[i].ApplyExec;
				var ApplyStatusCode=rows[i].ApplyStatusCode;
				var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
				if((OrdBilled!="否")&&(ApplyStatusCode!="C")){
					RowIdArr.push(DCARowIds);
				}
			}	
		}else{
			RowIdArr=GetDCARowIDArr();	
		}
		if(RowIdArr.length==0){
			$.messager.alert('提示','未有可进行评估的治疗申请,请确认申请是否已缴费或是否已撤消!',"warning");
			return false;	
		}

		var RowIDStr=RowIdArr.join(String.fromCharCode(1));
		OpenCureAssDiagBatch(RowIDStr,CureAssessmentDataGridLoad)
	}
	
	function UpdateAssessment(rowData){
		var myObj=GetSelectAssRow(rowData);
		if(myObj==""){return;}
		if(myObj.DCAssRowId==""){
			$.messager.confirm("提示","暂未评估无法修改,是否新增!",function(r){
				if(r){
					AddAssessment();
				}	
			});
		}else{
			var OperateType=$('#OperateType').val();
			OpenCureAssDiag(myObj,CureAssessmentDataGridLoad);
		}
	}
	
	function DeleteAssessment(){
		/*var myObj=GetSelectAssRow();
		if(myObj==""){return;}
		var DCAssRowId=myObj.DCAssRowId;
		if(DCAssRowId==""){
			$.messager.alert("提示","未做评估,无需删除!",'warning');
			return false;
		}*/
		var rows = CureAssessmentDataGrid.datagrid("getSelections");
		if (rows.length==0){
			$.messager.alert("提示","请选择一条评估记录",'warning');
			return false;
		}
		var DCAssRowIdStr="";
		var selIDAry=new Array();
		for(var i=0;i<rows.length;i++){
			var Rowid=rows[i].DCAssRowId;
			if(Rowid!=""){
				selIDAry.push(Rowid)
			}
		}
		if(selIDAry.length>0){
			DCAssRowIdStr=selIDAry.join("^");
		}
		if(DCAssRowIdStr==""){
			$.messager.alert("提示","未有可删除的评估记录!",'warning');
			return false;
		}
		$.messager.confirm('确认','是否确认删除选中的评估记录?',function(r){    
			if (r){ 
				var UpdateObj={}
				new Promise(function(resolve,rejected){
					//电子签名
					CASignObj.CASignLogin(resolve,"DelCureAss",false)
				}).then(function(CAObj){
					return new Promise(function(resolve,rejected){
				    	if (CAObj == false) {
				    		return websys_cancel();
				    	} else{
					    	$.extend(UpdateObj, CAObj);
					    	resolve(true);
				    	}
					})
				}).then(function(){
					$.cm({
						ClassName:"DHCDoc.DHCDocCure.Assessment",
						//MethodName:"DelCureAssessment",
						//Rowid:DCAssRowId,
						MethodName:"DelCureAssBatch",
						RowidStr:DCAssRowIdStr,
						UserDR:session['LOGON.USERID'],
						dataType:"text"	
					},function(value){
						var ErrMsg=value.split(String.fromCharCode(1))[0];
						var SuccessId=value.split(String.fromCharCode(1))[1];
						if(ErrMsg==0){
							$.messager.popover({msg: '删除成功!',type:'success',timeout: 2000});
							if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, SuccessId, "DelCureAss");
							CureAssessmentDataGridLoad();
						}else{
							$.messager.alert("提示",ErrMsg,'error');
						}
					})
				})
			}
		})
	}
	
	function GetSelectAssRow(rowData){
		if(typeof rowData == 'undefined'){
			var rows = CureAssessmentDataGrid.datagrid("getSelections");
			if (rows.length==0) 
			{
				$.messager.alert("提示","请选择一条评估记录",'warning');
				return "";
			}else if (rows.length>1){
		 		$.messager.alert("提示","您选择了多个评估记录！",'warning')
		 		return "";
			}
			rowData=rows[0];
		}
		var DCAssRowId=rowData.DCAssRowId;
		var DCARowId=rowData.DCARowId;
		var DCAssTempID=rowData.DCAssTempID;
		var DCAssAdmID=rowData.DCAssAdmID;
		var ApplyStatus=rowData.ApplyStatus;
		var OrdBilled=rowData.OrdBilled;
		if(DCARowId==""){
			$.messager.alert('提示','请选择一条评估记录','warning');
			return "";
		}
		if((OrdBilled=="否")||(ApplyStatus=="C")){
			$.messager.alert('提示','该治疗申请未缴费或者治疗申请已撤消,请确认.','warning');
			return "";
		}
		return {
			"DCAssRowId":DCAssRowId,
			"DCARowId":DCARowId,
			"AssAdmID":DCAssAdmID,
			"AssTempID":DCAssTempID	
		};
	}
	
	return{
		"InitCureAssessmentDataGrid":InitCureAssessmentDataGrid,
		"CureAssessmentDataGridLoad":CureAssessmentDataGridLoad	
	}
})()
