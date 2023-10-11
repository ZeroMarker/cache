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
				text:'����', 
				iconCls:'icon-add',  
				handler:function(){
					AddAssessment();
				}
			},{
				id:'BtnUpdate',
				text:'�޸�', 
				iconCls:'icon-write-order',  
				handler:function(){
					UpdateAssessment();
				}
			},{
				id:'BtnDelete',
				text:'ɾ��', 
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
			loadMsg : '������..',  
			pagination : true,
			rownumbers : true,
			idField:"DCAssRowId",
			pageSize : 10,
			pageList : [10,20,50],
			frozenColumns : [[
				{field:'RowCheck',checkbox:true},
				{field:'DCARowId',title:'',width:1,hidden:true}, 
				{field:'ApplyNo',title:'���뵥��',width:110,align:'left', resizable: true, hidden:hiddenCol},  
				{field:'PatientName',title:'����',width:80,align:'left', resizable: true, hidden:hiddenCol},   
				{field:'PatOther',title:'����������Ϣ',width:200,align:'left', resizable: true, hidden:hiddenCol},
				{field:'ArcimDesc',title:'������Ŀ',width:200,align:'left', resizable: true}
			]],
			columns :[[
				{field:'DCAssDate',title:'����ʱ��',width:150},
				{field:'DCAssTempTitile',title:'����ģ��',width:180},
				{field:'DCAssContent',title:'��������',width:350,
					formatter:function(value,row,index){
						if(row.DCAssRowId==""){
							return "<span class='fillspan'>"+$g("��δ����")+"</span>";
						}else{
							return "<span class='fillspan-nosave'>"+$g("˫���鿴��ϸ")+"</span>";
						}
					}
				},  
				{field:'DCAssUser',title:'������',width:90},
				{field:'DCAssLastUser',title:'��������',width:90},
				{field:'DCAssLastDate',title:'������ʱ��',width:150},
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
                            //��δ��ȡ������ģ��,��չʾ�򻯰�Ľ���
                            var myhref="doccure.cureassessment.hui.csp?OperateType="+"&EpisodeID="+DCAssAdmID+"&DCARowId="+DCARowId+"&DCAssRowId="+DCAssRowId+"&DCRowIdStr="+DCRowIDStr+"&PageShowFromWay="+ServerObj.PageShowFromWay;
                        }else{
                            var myhref="doccure.asstemp.hui.csp?DCARowId="+DCARowId+"&DCAssRowId="+DCAssRowId+"&OperateType=&DCRowIDStr="+DCRowIDStr+"&DCAssTempID="+DCAssTempID+"&DCAdmID="+DCAssAdmID+"&PageShowFromWay="+ServerObj.PageShowFromWay;
                        }
                        var frameurl=myhref.replace(/&/g,"!@")
                        websys_emit("onOpenDHCDoc",{title:"��������",frameurl:frameurl});
                    }else if (DCARowId!=""){
                        // չʾ��������������Ϣ
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
			//��Ϊҳǩ��ʽ��id��PageAppListAllObj��ȡ
			DCAARowIdStr=PageAppListAllObj._SELECT_DCAROWID;
		}else if(typeof(PageWorkListAllObj)!="undefined"){
			//���ƹ���ƽ̨��������
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
			$.messager.alert("��ʾ","��ȡ��Ҫ��������", 'error');
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
			$.messager.alert("��ʾ","��ȡ���������Ӵ���", 'error');
		}
	}
	
	function OpenCureAssDiag(AssTempObj,callBack)
	{
		if(typeof AssTempObj != "object"){
			$.messager.alert("��ʾ","��ȡ��Ҫ��������", 'error');
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
			//��δ��ȡ������ģ��,��չʾ�򻯰�Ľ���
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
			$.messager.alert("��ʾ","��ȡ���������Ӵ���", 'error');
		}
	}
	
	function OpenCureDiag(href,callBack,diagH,diagW){
		var diagW=diagW||"1200px";
		var diagH=diagH||"900px";
		websys_showModal({
			url:href,
			iconCls:"icon-w-paper",
			title:'����������¼',
			width:diagW,height:diagH,
			onClose: function() {
				callBack();
			}
		});
	}
	
	/*
		��������������¼
		����ԤԼ��������-��ȡ�����������뵥ID��Ϣ
		���ƴ����������-����ѡ�������ԤԼ��Ϣ�õ����뵥ID��Ϣ
	*/
	function AddAssessment(){
		var RowIdArr=new Array();
		if(typeof(CureApplyDataGrid)=="object"){
			var rows = CureApplyDataGrid.datagrid("getSelections");
			if (rows.length==0) 
			{
				$.messager.alert("��ʾ","��ѡ��һ�����뵥","warning");
				return false;
			}
			var DCARowIdStr=""
			for(var i=0;i<rows.length;i++){
				var DCARowIds=rows[i].DCARowId;
				var OrdBilled=rows[i].OrdBilled;
				var ApplyExec=rows[i].ApplyExec;
				var ApplyStatusCode=rows[i].ApplyStatusCode;
				var rowIndex = CureApplyDataGrid.datagrid("getRowIndex", rows[i]);
				if((OrdBilled!="��")&&(ApplyStatusCode!="C")){
					RowIdArr.push(DCARowIds);
				}
			}	
		}else{
			RowIdArr=GetDCARowIDArr();	
		}
		if(RowIdArr.length==0){
			$.messager.alert('��ʾ','δ�пɽ�����������������,��ȷ�������Ƿ��ѽɷѻ��Ƿ��ѳ���!',"warning");
			return false;	
		}

		var RowIDStr=RowIdArr.join(String.fromCharCode(1));
		OpenCureAssDiagBatch(RowIDStr,CureAssessmentDataGridLoad)
	}
	
	function UpdateAssessment(rowData){
		var myObj=GetSelectAssRow(rowData);
		if(myObj==""){return;}
		if(myObj.DCAssRowId==""){
			$.messager.confirm("��ʾ","��δ�����޷��޸�,�Ƿ�����!",function(r){
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
			$.messager.alert("��ʾ","δ������,����ɾ��!",'warning');
			return false;
		}*/
		var rows = CureAssessmentDataGrid.datagrid("getSelections");
		if (rows.length==0){
			$.messager.alert("��ʾ","��ѡ��һ��������¼",'warning');
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
			$.messager.alert("��ʾ","δ�п�ɾ����������¼!",'warning');
			return false;
		}
		$.messager.confirm('ȷ��','�Ƿ�ȷ��ɾ��ѡ�е�������¼?',function(r){    
			if (r){ 
				var UpdateObj={}
				new Promise(function(resolve,rejected){
					//����ǩ��
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
							$.messager.popover({msg: 'ɾ���ɹ�!',type:'success',timeout: 2000});
							if (UpdateObj.caIsPass==1) CASignObj.SaveCASign(UpdateObj.CAObj, SuccessId, "DelCureAss");
							CureAssessmentDataGridLoad();
						}else{
							$.messager.alert("��ʾ",ErrMsg,'error');
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
				$.messager.alert("��ʾ","��ѡ��һ��������¼",'warning');
				return "";
			}else if (rows.length>1){
		 		$.messager.alert("��ʾ","��ѡ���˶��������¼��",'warning')
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
			$.messager.alert('��ʾ','��ѡ��һ��������¼','warning');
			return "";
		}
		if((OrdBilled=="��")||(ApplyStatus=="C")){
			$.messager.alert('��ʾ','����������δ�ɷѻ������������ѳ���,��ȷ��.','warning');
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
