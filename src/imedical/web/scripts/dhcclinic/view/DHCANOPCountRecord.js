
$.extend($.fn.datagrid.methods,{
	editCell:function(jq,param){
		return jq.each(function(){
			var opts=$(this).datagrid("options");
			var fields=$(this).datagrid("getColumnFields",true).concat($(this).datagrid("getColumnFields"));
			for(var i=0;i<fields.length;i++){
				var col=$(this).datagrid("getColumnOption",fields[i]);
				col.editor1=col.editor;
				if(fields[i]!=param.field){
					col.editor=null;
				}
			}
			
			$(this).datagrid("beginEdit",param.index);
			var ed=$(this).datagrid("getEditor",param);
			if(ed){
				if($(ed.target).hasClass("textbox-f")){
					$(ed.target).textbox("textbox").focus();
					$(ed.target).textbox("textbox").select();
					/*$(ed.target).textbox("textbox").keydown(function(e){
						var code=e.keyCode || e.which;
						if(code==13){
							$("#countRecord").datagrid("acceptChanges");
							$("#countRecord").datagrid("endEdit",0);
						}
						
					});*/
				}else{
					$(ed.target).focus();
				}
			}
			
			for(var i=0;i<fields.length;i++){
				var col=$(this).datagrid("getColumnOption",fields[i]);
				col.editor=col.editor1
			}
		});
	},
	enableCellEditing:function(jq,success){
		return jq.each(function(){
			var dg=$(this);
			var opts=dg.datagrid("options");
			opts.oldOnClickCell=opts.onClickCell;
			opts.onClickCell=function(index,field){
			if(opts.editIndex!=undefined){
				if(dg.datagrid("validateRow",opts.editIndex)){
					dg.datagrid("endEdit",opts.editIndex);
					opts.editIndex=undefined;
				}else
				{
					return;
				}
			}
			
			dg.datagrid("selectRow",index).datagrid("editCell",{
				index:index,
				field:field
			});
			
			opts.editIndex=index;
			opts.oldOnClickCell.call(this,index,field);
			success(index,field);
		}
		});
	}
});

var patientInfo="",
	operationInfo="",
	anaestInfo="",
	filePath="";
	
$(document).ready(function(){
	var opaId=getQueryString("opaId"),
		userId=getQueryString("userId");

	//self.moveTo(0,0);
	//self.resize(screen.availWidth,screen.availHeight);
	$("#countRecordInfo").panel({
		title:"����¼",
		iconCls:'icon-opercount',
		width:470,
		height:640,
		style:{"font-family":"΢���ź�","float":"left","padding":"0px 5px 5px 0px"},
		collapsible:true
	});
	$("#packageInfo").panel({
		title:"�޾���������",
		iconCls:'icon-packinfo',
		width:660,
		height:290,
		style:{"font-family":"΢���ź�","padding":"0"},
		collapsible:true
	});
	
	$("#patientInfo").panel({
		title:"��Ѫ",
		iconCls:'icon-bloodinfo',
		width:310,
		height:345,
		style:{"font-family":"΢���ź�","float":"left","padding":"0px 0px 5px 0px"},
		collapsible:true
	});
	
	$("#signInfo").panel({
		title:"ǩ��",
		iconCls:'icon-signinfo',
		width:350,
		height:345,
		style:{"font-family":"΢���ź�","float":"left","padding":"0px 0px 5px 5px"},
		collapsible:true
	});
	
	$("#packageBox").datagrid({
		fit:true,
		toolbar:"#packageTool",
		url:"dhcclinic.jquery.csp",
		queryParams:{
			ClassName:"web.DHCANCOPCount",
			QueryName:"FindSterExpByLabel",
			Arg1:opaId,
			ArgCnt:1
		},
		method:"post",
		singleSelect:true,
		rownumbers:true,
		nowrap:true,
		columns:[[
			{field:"PackDesc",title:"����",width:120},
			{field:"SterilizingDate",title:"�������",width:100},
			{field:"SterilizingTime",title:"���ʱ��",width:80},
			{field:"ExpiredDate",title:"ʧЧ����",width:100},
			{field:"ExpiredTime",title:"ʧЧʱ��",width:100},
			{field:"QualifiedDesc",title:"ʧЧ���",width:80},
			{field:"Qualified",title:"Qualified",width:1,hidden:true}
		]],
		onSelect:function(rowIndex,rowData){
			$("#packageDesc").textbox("setValue",rowData.PackDesc);
			$("#dateOfDef").datebox("setValue",rowData.SterilizingDate);
			$("#timeOfDef").textbox("setValue",rowData.SterilizingTime);
			$("#expirationDT").datebox("setValue",rowData.ExpiredDate);
			$("#timeOfexpiration").textbox("setValue",rowData.ExpiredTime);
			$('#isQualified').combobox("setText",rowData.QualifiedDesc);
			//$("#packId").val(rowData.Id);
		}
	});
	
	$("#countRecord").datagrid({
		fit:true,
		toolbar:"#recordTool",
		url:"dhcclinic.jquery.csp",
		queryParams:{
			ClassName:"web.DHCANCOPCount",
			QueryName:"FindTypeSel",
			Arg1:"",
			Arg2:opaId,
			Arg3:"",
			ArgCnt:"3"
		},
		method:"post",
		singleSelect:true,
		//pagination:true,
		rownumbers:true,
		nowrap:true,
		//pageSize:25,
		//pageList:[20,25,30,40,50,100,200],
		columns:[[
			{field:"OPCountDesc",title:"��е����",width:100},
			{field:"tPreOperNum",title:"��ǰ���",width:65,editor:{type:"numberbox"}},
			{field:"tAddNum",title:"������",width:50,editor:{type:"numberbox"}},
			{field:"tUnSewNum",title:"��ǰ�˶�",width:65,editor:{type:"numberbox"}},
			{field:"tSewedNum",title:"�غ�˶�",width:65,editor:{type:"numberbox"}},
			{field:"tSkinSewedNum",title:"��Ƥ��˶�",width:85,editor:{type:"numberbox"}},
			{field:"tGuiGe",title:"���",width:60},
			{field:"tANOPCId",title:"tANOPCId",width:1,hidden:true},
			{field:"operators",title:"",width:1,formatter: function(value,row,index){
					return '<a href="#" title="ɾ������" id="btnDelete" class="delete_instrument easyui-linkbutton" iconcls="icon-remove">ɾ��</a>';
				}
			,hidden:true},
		]],
		rowStyler:function(index,row){
			var preOPNum=parseInt(row.tPreOperNum),
				addNum=parseInt(row.tAddNum),
				unSewNum=parseInt(row.tUnSewNum),
				sewedNum=parseInt(row.tSewedNum),
				SkinSewedNum=parseInt(row.tSkinSewedNum),
				totalNum=preOPNum+addNum;
			if(totalNum!=unSewNum || totalNum!=sewedNum || totalNum!=SkinSewedNum){
				row.title="����ǰ��һ��,��˶�����!";
				return "background-color:#FFCCCC;";
			}
			else
			{
				row.title="";
			}
			
		}
	});
	
	$("#countRecord").datagrid("enableCellEditing",function(index,field){
		var param={index:index,field:field};
		var ed=$("#countRecord").datagrid("getEditor",param);
		if(ed){
			if($(ed.target).hasClass("textbox-f")){
					$(ed.target).textbox("textbox").keydown(function(e){
						var code=e.keyCode || e.which;
						if(code==13){
							$("#countRecord").datagrid("acceptChanges");
							$("#countRecord").datagrid("endEdit",0);
							var rows=$("#countRecord").datagrid("getRows");
							var currentRow=rows[index];
							if(field=="tPreOperNum" || field=="tAddNum"){
								var totalCount=parseInt(currentRow.tPreOperNum)+parseInt(currentRow.tAddNum);
								$("#countRecord").datagrid("updateRow",{
									index:index,
									row:{
										tUnSewNum:totalCount,
										tSewedNum:totalCount,
										tSkinSewedNum:totalCount
									}
								});
							}
							
							$.post("dhcclinic.jquery.method.csp",{
									ClassName:"web.DHCANCOPCount",
									MethodName:"UpdateCount",
									Arg1:currentRow.OPCountId,
									Arg2:currentRow.tANOPCId,
									Arg3:currentRow.tOriginalNum,
									Arg4:currentRow.tPreOperNum,
									Arg5:currentRow.tAddNum,
									Arg6:currentRow.tUnSewNum,
									Arg7:currentRow.tSewedNum,
									Arg8:currentRow.tSkinSewedNum,
									ArgCnt:8
								},function(data){
									//alert(data);
								}
							);
						}
						
				});
			}
		}
	});
	
	$("#btnAddPack").click(function(){
				//2010923+dyl
		if($("#packageDesc").textbox("getValue")=="")
		{
			$.messager.alert("��ʾ","�޾������Ʋ���Ϊ�գ�")
			return;
		}
		var packParam="^^"+$("#packageDesc").textbox("getValue")+"^"+$("#dateOfDef").datebox("getValue")+"^"+$("#timeOfDef").textbox("getValue")+"^"+$("#expirationDT").datetimebox("getValue")+"^"+$("#timeOfexpiration").textbox("getValue")+"^"+$("#isQualified").combobox("getValue");
		$("#packageDesc").textbox("setValue","");
					$("#packageDesc").textbox("setValue","");
					$("#dateOfDef").datebox("setValue","");
					$("#timeOfDef").textbox("setValue","");
					
					$("#expirationDT").datebox("setValue","");
					$("#timeOfexpiration").textbox("setValue","");
					$("#isQualified").combobox("setValue","");
		$.post("dhcclinic.jquery.method.csp",{
			ClassName:"web.DHCANOPSterilityPack",
			MethodName:"SaveSterilityPack",
			Arg1:opaId,
			Arg2:packParam,
			ArgCnt:2
		},function(data){
			var packIdString=data.replace(/[\r\n]/g,"").replace(/\ +/g,"");
			var packId=parseInt(packIdString);
			//alert(packId);
			if(packId>0){
					
					$("#packageBox").datagrid("reload");
					$.messager.alert("��ʾ","����޾����������ɹ���","info");
			}
			else{
				$.messager.alert("��ʾ","����޾���������ʧ�ܣ�","info");
			}
			
		});
	});
	
	$("#btnSavePack").click(function(){
		if($("#packId").val()==""){
			$.messager.alert("��ʾ","����ѡ���޾�����������","info");
			return;
		}
			//2010923+dyl
		if($("#packageDesc").textbox("getValue")=="")
		{
			$.messager.alert("��ʾ","�޾������Ʋ���Ϊ�գ�")
			return;
		}
		var packParam=$("#packId").val()+"^^"+$("#packageDesc").textbox("getValue")+"^"+$("#dateOfDef").datebox("getValue")+"^"+$("#timeOfDef").textbox("getValue")+"^"+$("#expirationDT").datetimebox("getValue")+"^"+$("#timeOfexpiration").textbox("getValue")+"^"+$("#isQualified").combobox("getValue");
		//var packParam=$("#packId").val()+"^^"+$("#packageDesc").textbox("getValue")+"^"+$("#timeOfDef").datetimebox("getValue")+"^"+$("#expirationDT").datetimebox("getValue")+"^"+$("#isQualified").combobox("getValue");
					
		$.post("dhcclinic.jquery.method.csp",{
			ClassName:"web.DHCANOPSterilityPack",
			MethodName:"SaveSterilityPack",
			Arg1:opaId,
			Arg2:packParam,
			ArgCnt:2
		},function(data){
			var packIdString=data.replace(/[\r\n]/g,"").replace(/\ +/g,"");
			var packId=parseInt(packIdString);
			if(packId>0){
	//20160923+dyl
		$("#packageDesc").textbox("setValue","");
		$("#packageDesc").textbox("setValue","");
		$("#dateOfDef").datebox("setValue","");
		$("#timeOfDef").textbox("setValue","");
					
		$("#expirationDT").datebox("setValue","");
		$("#timeOfexpiration").textbox("setValue","");
		$("#isQualified").combobox("setValue","");
					$("#packageBox").datagrid("reload");
				$.messager.alert("��ʾ","�����޾����������ɹ���","info",function(){
					
				});
			}else{
				$.messager.alert("��ʾ","�����޾���������ʧ�ܣ�","info");
			}
			
			
		});
	});
	
	$("#saveInstruments").click(function(){
		$("#countRecord").datagrid("acceptChanges");
		var currentRows=$("#countRecord").datagrid("getRows");
		$.each(currentRows,function(ind,e){
			var currentRow=e;
			$.post("dhcclinic.jquery.method.csp",{
					ClassName:"web.DHCANCOPCount",
					MethodName:"UpdateCount",
					Arg1:currentRow.OPCountId,
					Arg2:currentRow.tANOPCId,
					Arg3:currentRow.tOriginalNum,
					Arg4:currentRow.tPreOperNum,
					Arg5:currentRow.tAddNum,
					Arg6:currentRow.tUnSewNum,
					Arg7:currentRow.tSewedNum,
					Arg8:currentRow.tSkinSewedNum,
					ArgCnt:8
				},function(data){
					//alert(data);
				}
			);
		});
		$.messager.alert("��ʾ","����¼����ɹ���","info");
	});
	
		$("#insertCSSDPack").click(function(){
		var CSSDPackId=$("#packageNo").textbox("getValue");
		$.post("dhcclinic.jquery.method.csp",{
			ClassName:"web.DHCANCOPCount",
			MethodName:"CheckPackValid",
			Arg1:CSSDPackId,
			ArgCnt:1
		},function(data){
			if(data.replace(/[\r\n]/g,"").replace(/\ +/g,"")=="0"){
				$.post("dhcclinic.jquery.method.csp",{
					ClassName:"web.DHCANCOPCount",
					MethodName:"InsertCSSDPackegItem",
					Arg1:CSSDPackId,
					Arg2:opaId,
					ArgCnt:2
				},function(data2){
					if(data2.replace(/[\r\n]/g,"").replace(/\ +/g,"")=="0"){
						$.messager.alert("��ʾ","ͬ���������ɹ���","info");
						$("#countRecord").datagrid("reload");
						$("#packageBox").datagrid("reload");
					}
					else
					{
						alert(data2);
						$.messager.alert("��ʾ","ͬ��������ʧ�ܣ�","error");
					}
				});
				//
			}
			else
			{
			
						$.messager.alert("��ʾ",data,"error");
					
			}
		});
	});
	
	//ɾ����е YuanLin 20170831
	$("#delInstruments").click(function()
	{
		removeInstrument();
	});
	
	$("#btnRemovePack").click(function(){
		if($("#packId").val()==""){
			$.messager.alert("��ʾ","����ѡ���޾�����������","info");
			return;
		}
		//var packParam=$("#packId").val()+"^^"+$("#packageDesc").combobox("getText")+"^"+$("#timeOfDef").datetimebox("getValue")+"^"+$("#expirationDT").datetimebox("getValue")+"^"+$("#isQualified").combobox("getValue");
		
		$.messager.confirm("ȷ��","����ȷ���Ƿ�ɾ��"+$("#packageDesc").textbox("getValue")+"��",function(ret){
			if(ret){
				$.post("dhcclinic.jquery.method.csp",{
					ClassName:"web.DHCANOPSterilityPack",
					MethodName:"RemoveSterilityPack",
					Arg1:$("#packId").val(),
					ArgCnt:1
				},function(data){
					if(data.replace(/[\r\n]/g,"").replace(/\ +/g,"")=="0"){
						$.messager.alert("��ʾ","ɾ���޾����������ɹ���","info",function(){
							//20160923+dyl
					$("#packageDesc").textbox("setValue","");
					$("#dateOfDef").datebox("setValue","");
					$("#timeOfDef").textbox("setValue","");
					
					$("#expirationDT").datebox("setValue","");
					$("#timeOfexpiration").textbox("setValue","");
					$("#isQualified").combobox("setValue","");

							$("#packageBox").datagrid("reload");
						});
					}else{
						$.messager.alert("��ʾ","ɾ���޾���������ʧ�ܣ�","error");
					}
				});
			}
		});
		
	});
	
	
	$("#OPC_PreOPScrubNurseSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="NURSE"){
					$.messager.alert("����","���û����Ͳ��ǻ�ʿ�������뻤ʿ�û����˺ţ�","error",function(){
						$("#OPC_PreOPScrubNurseSign").focus();
					});
					
					return;
				}
				$("#OPC_PreOPScrubNurseSign").val(dataArr[4]);
				$("#OPC_PreOPScrubNurseSignId").val(dataArr[3]);
			});
		}
	});
	
	$("#OPC_PreOPCirculNurseSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="NURSE"){
					$.messager.alert("����","���û����Ͳ��ǻ�ʿ�������뻤ʿ�û����˺ţ�","error",function(){
						$("#OPC_PreOPCirculNurseSign").focus();
					});
					
					return;
				}
				$("#OPC_PreOPCirculNurseSign").val(dataArr[4]);
				$("#OPC_PreOPCirculNurseSignId").val(dataArr[3]);
			});
		}
	});
	
	$("#OPC_PreCloseScrubNurseSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="NURSE"){
					$.messager.alert("����","���û����Ͳ��ǻ�ʿ�������뻤ʿ�û����˺ţ�","error",function(){
						$("#OPC_PreCloseScrubNurseSign").focus();
					});
					
					return;
				}
				$("#OPC_PreCloseScrubNurseSign").val(dataArr[4]);
				$("#OPC_PreCloseScrubNurseSignId").val(dataArr[3]);
			});
		}
	});
	
	$("#OPC_PreCloseCirculNurseSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="NURSE"){
					$.messager.alert("����","���û����Ͳ��ǻ�ʿ�������뻤ʿ�û����˺ţ�","error",function(){
						$("#OPC_PreCloseCirculNurseSign").focus();
					});
					
					return;
				}
				$("#OPC_PreCloseCirculNurseSign").val(dataArr[4]);
				$("#OPC_PreCloseCirculNurseSignId").val(dataArr[3]);
			});
		}
	});
	
	$("#OPC_PostCloseScrubNurseSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="NURSE"){
					$.messager.alert("����","���û����Ͳ��ǻ�ʿ�������뻤ʿ�û����˺ţ�","error",function(){
						$("#OPC_PostCloseScrubNurseSign").focus();
					});
					
					return;
				}
				$("#OPC_PostCloseScrubNurseSign").val(dataArr[4]);
				$("#OPC_PostCloseScrubNurseSignId").val(dataArr[3]);
			});
		}
	});
	
	$("#OPC_PostCloseCirculNurseSign").keypress(function(e){
		if(e.which==13){
			$.post("dhcclinic.jquery.method.csp",{
				ClassName:"web.DHCClinicCom",
				MethodName:"GetUserInfoByInitials",
				Arg1:$(this).val(),
				ArgCnt:"1"
			},function(data){
				var dataArr=data.split("^");
				if(dataArr[0].Trim()!="NURSE"){
					$.messager.alert("����","���û����Ͳ��ǻ�ʿ�������뻤ʿ�û����˺ţ�","error",function(){
						$("#OPC_PostCloseCirculNurseSign").focus();
					});
					
					return;
				}
				$("#OPC_PostCloseCirculNurseSign").val(dataArr[4]);
				$("#OPC_PostCloseCirculNurseSignId").val(dataArr[3]);
			});
		}
	});
	
	
	
	//��������
	$("#btnSave").click(function(){
		//saveElementValue(opaId,"transBloodInfo",userId,true);
		//saveElementValue(opaId,"signInfo",userId,true);
		///update by lyn 20161013  ��׼��bug����
		var saveRet1=saveElementValue(opaId,"transBloodInfo",userId,true);
		if(saveRet1==0){$.messager.alert("��ʾ","�ɹ�������Ѫ���ݣ�","info");}
		var saveRet2=saveElementValue(opaId,"signInfo",userId,true);
		if(saveRet2==0){$.messager.alert("��ʾ","�ɹ�����ǩ�����ݣ�","info");}
	});
	
	
	$("#Print").click(function(){
		printCheckingRecord();
	});
	
	var bannerInfo=""
	//ȡ��е������
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANCOPCount",QueryName:"FindOPCountType",Arg1:"",ArgCnt:"1"},
	    function(data){
	    	$("#countType").combobox({
				valueField:"TypeId",
				textField:"TypeDesc",
				style:'border:1px solid orange;',
				data:data.rows,
				onSelect:function(record){
					$.messager.confirm("ȷ��","ȷ��Ҫ���"+record.TypeDesc+"���͵�������е��",function(ret){
						if(ret){
							$.post("dhcclinic.jquery.method.csp",{ClassName:"web.DHCANCOPCount",MethodName:"InsertDefCountItem",Arg1:record.TypeId,Arg2:opaId,ArgCnt:"2"},function(data){
								if(+data!=0)
								{
									alert(data);   //YuanLin 20170830
								}
							$("#countRecord").datagrid("reload");
							});
						}
					});
				}
			});
	},"json").error(function(result){
		alert(result.statusText);
	});
	
	$("#countItem").combobox({
		valueField:"tOPCountId",
		textField:"OPCountDesc"
	});
	$.post("dhcclinic.jquery.method.csp",{ClassName:"websys.Conversions",MethodName:"DateFormat",ArgCnt:"0"},
	function(data){
		showfamat=data
	});
	//ȡ��е
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANCOPCount",QueryName:"FindOPCount",Arg1:"",Arg2:$("#countItem").combobox("getText"),Arg3:"",ArgCnt:"3"},
	    function(data){
	    	$("#countItem").combobox({
				data:data.rows,
				onSelect:function(record){
					$.messager.confirm("ȷ��","ȷ��Ҫ���"+record.OPCountDesc+"��",function(ret){
						if(ret){
							$.post("dhcclinic.jquery.method.csp",
								{
									ClassName:"web.DHCANCOPCount",
									MethodName:"AddCount",
									Arg1:record.tOPCountId,
									Arg2:opaId,
									Arg3:0,
									Arg4:0,
									Arg5:0,
									Arg6:0,
									Arg7:0,
									Arg8:0,
									ArgCnt:"8"
								},function(data){
								var dataArray=data.split("^");
								if(dataArray[0].replace(/[\r\n]/g,"").replace(/\ +/g,"")=="0"){
									$("#countRecord").datagrid("appendRow",{
										tANOPCId:record.tOPCountId,
										OPCountDesc:record.OPCountDesc,
										OPCountId:dataArray[1],
										tOriginalNum:0,
										tPreOperNum:0,
										tAddNum:0,
										tUnSewNum:0,
										tSewedNum:0,
										tSkinSewedNum:0
									});
									$("#countRecord").datagrid("reload");
									var rows=$("#countRecord").datagrid("getRows");
									$("#countRecord").datagrid("selectRow",rows.length-1);
									
								}
							});
							$("#countRecord").datagrid("reload");	//�������е֮��ˢ��һ�Σ������ȡ����idɾ�����ɹ�+20160923+dyl
						}
					});
				}
			});
	},"json").error(function(result){
		alert(result.statusText);
	});
	//ȡ������Ϣ
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindPatientInfo",Arg1:opaId,ArgCnt:"1"},
	    function(data){
	    	patientInfo=data.rows[0];
			
	    	$("#patName").text("����������"+patientInfo.Name);
	    	$("#gender").text("�Ա�"+patientInfo.Gender);
	    	$("#age").text("���䣺"+patientInfo.Age);
	    	$("#dept").text("�Ʊ�"+patientInfo.Location);
	    	$("#medicareNo").text("סԺ�ţ�"+patientInfo.MedicareNo);
			$("#bedNo").text("���ţ�"+patientInfo.BedCode);
			
			bannerInfo="����������"+patientInfo.Name+"  �Ա�"+patientInfo.Gender+"  ���䣺"+patientInfo.Age+"  �Ʊ�"+patientInfo.Location;
	//-----������+20161025+��Ųλ�ã��򿪴�����һ����title��ʾ��ͬ
	if(bannerInfo!="")
	{
		//ȡ������Ϣ
		$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindOperationInfo",Arg1:opaId,ArgCnt:"1"},
			function(data){
				operationInfo=data.rows[0];
				$("#operationDate").text("�������ڣ�"+operationInfo.OperationDate);
				$("#operation").text("�������ƣ�"+operationInfo.Operation);
				bannerInfo=bannerInfo+"  �������ƣ�"+operationInfo.Operation;
				$(document).attr("title","��������¼-"+bannerInfo);
		},"json");
	}
	//---------end
	
	},"json").error(function(result){
	});
	/*
	//ȡ������Ϣ
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindOperationInfo",Arg1:opaId,ArgCnt:"1"},
		function(data){
			operationInfo=data.rows[0];
			$("#operationDate").text("�������ڣ�"+operationInfo.OperationDate);
			$("#operation").text("�������ƣ�"+operationInfo.Operation);
			bannerInfo+="  �������ƣ�"+operationInfo.Operation;
			$(document).attr("title","��������¼-"+bannerInfo);
	},"json");
	*/
	//ȡ������Ϣ
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindAnaestInfo",Arg1:opaId,ArgCnt:"1"},
		function(data){
			anaestInfo=data.rows[0];
			$("#planAnaestMethod").text("������ʽ��"+anaestInfo.PlanAnaMethod);
	},"json");
	//alert(bannerInfo);
	
	
	//��ȡ�Ѿ������ֵ
	$.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANOPArrangeExtend",QueryName:"FindArrangeExtendValue",Arg1:opaId,Arg2:"OPC",ArgCnt:"2"},
	function(data){
		if(data && data.rows && data.rows.length>0){
			$.each(data.rows,function(index,dataItem){
				if(dataItem.ExtendItemCode && dataItem.Value){
					var extendItem=document.getElementById(dataItem.ExtendItemCode);
					if(extendItem){
						if(dataItem.Value=="true"){
							extendItem.checked=true;
							$("#"+dataItem.ExtendItemCode).attr("class","label_on");
						}
						else if(dataItem.Value=="false")
						{
							extendItem.checked=false;
							$("#"+dataItem.ExtendItemCode).attr("class","label_off");
						}
						else
						{
							extendItem.value=dataItem.Value;
						}
						
						switch(dataItem.ExtendItemCode){
							case "OPV_PreVisitTime":
							case "OPV_FirstVisitTime":
							case "OPV_SecondVisitTime":
							case "OPV_ThirdVisitTime":
							case "OPV_PostVisitTime":
								if(dataItem.Value && dataItem.Value!=""){
									$("#"+dataItem.ExtendItemCode).datetimebox("setValue",dataItem.Value);
								}
								
								break;
						}
					}
				}
			});
		}
	},"json");
	
	// ��ӡģ��·��
	$.post("dhcclinic.jquery.method.csp",{ClassName:"web.DHCLCNUREXCUTE",MethodName:"GetPath",ArgCnt:"0"},
	function(data){
		filePath=data;
	});
});

function removeInstrument()
{
	var selectedRow=$("#countRecord").datagrid("getSelected");
	if(selectedRow)
	{
		var selectedIndex=$("#countRecord").datagrid("getRowIndex",selectedRow);
		$.messager.confirm("ȷ��","��ȷ��Ҫɾ��"+selectedRow.OPCountDesc+"��",function(ret){
			if(ret){
				$.post("dhcclinic.jquery.method.csp",{
						ClassName:"web.DHCANCOPCount",
						MethodName:"DeleteCount",
						Arg1:selectedRow.tANOPCId,
						ArgCnt:1
					},function(data){
						if(data.replace(/[\r\n]/g,"").replace(/\ +/g,"")=="0"){
							//$.messager.alert("��ʾ","�ɹ�ɾ��������е��","info");
							$("#countRecord").datagrid("deleteRow",selectedIndex);
						}else{
							$.messager.alert("��ʾ","ɾ��������еʧ�ܣ�","error");
						}
				});
			}
		});
	}
	else
	{
		$.messager.alert("��ʾ","����ѡ��һ��������е��","info");
	}
}


function printCheckingRecord(){
		
	//����excel
	var excel=null,
		workBook=null,
		sheet=null;
	try{
		excel=new ActiveXObject("Excel.Application");
	}
	catch(e){
		$.messager.alert("����","�����δ��װExcel���ӱ��������Ȱ�װ��","error");
	}
	
	var fileName=filePath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"DHCANOPCountRecord.xlsx";
	try{
		workBook=excel.Workbooks.open(fileName);
		sheet=workBook.Worksheets(1);
		
		sheet.Range("A1").Value= patientInfo.hospitalDesc+"������㵥";  //ҽԺ����  YuanLin 20170828
		//������Ϣ	
	    sheet.Range("G2").Value= patientInfo.Name;	//����
	    sheet.Range("K2").Value= patientInfo.Gender;	//�Ա�
	    sheet.Range("M2").Value= patientInfo.Age;	//����
		//sheet.Range("E2").Value= patientInfo.BedCode;	//����
	    sheet.Range("C2").Value= patientInfo.Location;	//����
	    var opaId=getQueryString("opaId");
	    $.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindOperationInfo",Arg1:opaId,ArgCnt:"1"},
			function(data){
				operationInfo=data.rows[0];
		},"json");
	    sheet.Range("C3").Value= operationInfo.OperationDate;	//��������
	  
	    sheet.Range("G3").Value= operationInfo.Operation;	//��������
	    sheet.Range("M4").Value= patientInfo.RegisterNo;	//�ǼǺ�
		sheet.Range("C4").Value= $("#OPC_TransBlood_BloodType").val();	//Ѫ��
		sheet.Range("F4").Value= $("#OPC_TransBlood_BloodDesc").val();	//�ɷ�
		sheet.Range("J4").Value= $("#OPC_TransBlood_BloodVolume").val();	//Ѫ��
		
		var rows=$("#countRecord").datagrid("getRows");
		var limitRowCount=21,
			startRow=7,
			currentRow=startRow;
		for(var i=0;i<limitRowCount;i++){
			if(i>=rows.length) break;
			var addNum=parseInt(rows[i].tAddNum);
			var preNum=parseInt(rows[i].tPreOperNum);
			var unSewNum=parseInt(rows[i].tUnSewNum);
			var sewedNum=parseInt(rows[i].tSewedNum);
			var SkinSewedNum=parseInt(rows[i].tSkinSewedNum);
			var total=preNum+addNum;
			var countdesc=rows[i].OPCountDesc;

			if((total!=unSewNum) || (total!=sewedNum) || (total!=SkinSewedNum)){
				alert(countdesc+"����ǰ��һ��,��˶�����!");
				return;
			}

			sheet.Range("B"+currentRow).Value=rows[i].OPCountDesc;
			sheet.Range("C"+currentRow).Value=rows[i].tPreOperNum;
			sheet.Range("D"+currentRow).Value=rows[i].tAddNum;
			sheet.Range("E"+currentRow).Value=rows[i].tUnSewNum;
			sheet.Range("F"+currentRow).Value=rows[i].tSewedNum;
			sheet.Range("G"+currentRow).Value=rows[i].tSkinSewedNum;
			currentRow++;
		}
		
		if(rows.length>limitRowCount){
			currentRow=startRow;
			for(var i=limitRowCount;i<rows.length;i++){
				if(i>=rows.length) break;
				sheet.Range("I"+currentRow).Value=rows[i].OPCountDesc;
				sheet.Range("J"+currentRow).Value=rows[i].tPreOperNum;
				sheet.Range("K"+currentRow).Value=rows[i].tAddNum;
				sheet.Range("L"+currentRow).Value=rows[i].tUnSewNum;
				sheet.Range("M"+currentRow).Value=rows[i].tSewedNum;
				sheet.Range("N"+currentRow).Value=rows[i].tSkinSewedNum;
				currentRow++;
			}
		}
		
		sheet.Range("F29").Value= $("#OPC_PreOPScrubNurseSign").val();
		sheet.Range("F30").Value= $("#OPC_PreOPCirculNurseSign").val();
		sheet.Range("F31").Value= $("#OPC_PreCloseScrubNurseSign").val();
		sheet.Range("J29").Value= $("#OPC_PreCloseCirculNurseSign").val();
		sheet.Range("J30").Value= $("#OPC_PostCloseScrubNurseSign").val();
		sheet.Range("J31").Value= $("#OPC_PostCloseCirculNurseSign").val();
	    
	    sheet=workBook.Worksheets(2);
		sheet.Select();
		/*
		//������Ϣ	
	    sheet.Range("H2").Value= patientInfo.Name;
	    sheet.Range("K2").Value= patientInfo.Gender;
	    sheet.Range("M2").Value= patientInfo.Age;
			sheet.Range("F2").Value= patientInfo.BedCode;
	    sheet.Range("C2").Value= patientInfo.Location;
	    sheet.Range("D3").Value= operationInfo.OperationDate;
	    sheet.Range("I3").Value= operationInfo.Operation;
	    sheet.Range("O2").Value= patientInfo.RegisterNo;
	    */
	    /*
		limitRowCount=10;
		currentRow=startRow;
		var packRows=$("#packageBox").datagrid("getRows");
		for(var i=0;i<limitRowCount;i++){
			if(i>=packRows.length) break;
			sheet.Range("B"+currentRow).Value=packRows[i].PackDesc;
			sheet.Range("G"+currentRow).Value=packRows[i].SterilizingTime;
			sheet.Range("K"+currentRow).Value=packRows[i].ExpiredTime;
			sheet.Range("N"+currentRow).Value=packRows[i].Qualified;
			currentRow++;
		}
		*/
		
	    workBook.Worksheets.PrintOut();
	    sheet=null;
	    workBook.Close(savechanges=false);
	    workBook=null;
	}
	catch(e){
		$.messager.alert("����","δ�ҵ���ӡģ�壬��ȷ�ϴ�ӡģ���·���Ƿ���ȷ��"+e.description,"error");
	}
	
	
	excel.Quit();
	excel=null;
}



function saveElementValue(opaId,OPSStatus,userId,editStatus){
	var subSplitChar=String.fromCharCode(3),mainSplitChar="^",singleValue="",value="";
	
	$("#"+OPSStatus).find("input").each(function(index,element){
		
		switch($(this).attr("type")){
			
			case "checkbox":
				singleValue=$(this).attr("id")+subSplitChar+$(this).is(":checked")+subSplitChar;
				break;
			case "text":
				switch($(this).attr("id")){
					case "OPV_PreVisitTime":
					case "OPV_FirstVisitTime":
					case "OPV_SecondVisitTime":
					case "OPV_ThirdVisitTime":
					case "OPV_PostVisitTime":
						singleValue=$(this).attr("id")+subSplitChar+$("#"+$(this).attr("id")).datetimebox("getValue")+subSplitChar;
						break;
					default:
						singleValue=$(this).attr("id")+subSplitChar+$(this).val()+subSplitChar;
						break;
				}
				
				break;
		}
		//alert($(this).attr("id")+":"+$(this).attr("type")+"/"+OPSStatus+"%"+singleValue)
		//alert(OPSStatus+"/"+value)
		if(value!=""){
			value=value+mainSplitChar;
		}
		value=value+singleValue;
		
	});
	/*
	if(value && value!=""){
		$.post("dhcclinic.jquery.method.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANOPArrangeExtend",MethodName:"SaveArrangeExtend",Arg1:opaId,Arg2:value,Arg3:userId,ArgCnt:"3"},
		function(data){
			if(data.Trim()==""){
				$.messager.alert("��ʾ","�ɹ��������ݣ�","info");
				
			}
			else
			{
				$.messager.alert("����","��������ʧ�ܣ�ԭ��"+data,"error");
			}
			
		});
	}/*/
	if(value && value!=""){
		$.ajax({
			async:false,
			type:"post",
			url:"dhcclinic.jquery.method.csp?time="+(new Date()).getTime(),
			data:{
				ClassName:"web.DHCANOPArrangeExtend",
				MethodName:"SaveArrangeExtend",
				Arg1:opaId,
				Arg2:value,
				Arg3:userId,
				ArgCnt:3
			},
			success:function(data){
				if(data.Trim()=="") 
				{
					saveRet=0
				}
				else 
				{
					saveRet=-1;
					$.messager.alert("����","��������ʧ�ܣ�ԭ��"+data,"error");
				}
			}
		});
	}
	return saveRet
}
   $.fn.datebox.defaults.formatter = function(date){
	   //##class(websys.Conversions).DateFormat()
	   var formatnum=""
	   $.post("dhcclinic.jquery.method.csp",{ClassName:"websys.Conversions",MethodName:"DateFormat",ArgCnt:"0"},
	function(data){
		formatnum=data;
	});
	formatnum=4
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if(formatnum==3) datestr= y+'-'+m+'-'+d;
	else if(formatnum==4) datestr= d+'/'+m+'/'+y;
	return datestr;
}