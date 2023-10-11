/*
Creater:	jm
CreateDate：2023-02-13
Description:东软国家医保处方流转统一封装JS
*********************************************
<1>概念介绍
处方流转:是指系统连接医院,并将院内处方以电子化的形式同步流转至院外的指定零售药房,随后患者可通过
	该电子处方内的信息向指定实体药房及电商平台处购买到包括处方药在内的相关医药商品的过程.
双通道:是指两种买药途径——定点医院或定点药店.医保部门通过"双通道",保障患者能够买到已纳入医保的谈判药,
	与此同时,保障患者在定点医药机构购买谈判药品时能享受到医保报销待遇，且报销政策一致.
<2>HIS改造建议方案(和接口没有关系,主要是为了独立出HIS的流程)
1、新增双通道药房的接收科室,后续根据接收科室判断是否上传
2、新增子类及对应的双通道药品,便于区分及维护对应的接收科室;也可以使用原有数据,但是原有子类不一定都在流转目录里面
3、接收到双通道药房的药品进行库存导入,因为要去院外拿药,所有可以使用虚拟库存(不涉及医保接口,是为了走通HIS库存校验流程)
4、相关数据对照(界面: 医保业务配置->医保字典配置->医保系统配置（开发使用）)
	drugmedcwaycodeCon00A	给药途径对照医保
	usedfrquCon00A			频次对照医保
	PackUOMCon00			单位对照医保
	ProfttlCon00A			职称对照医保
	CredTypeCon00A			证件类型对照医保
<3>重点说明
1、医生开立医嘱后,由医生站发起调用,医保组进行上传,上传过程中所需数据,由医生站提供接口,接口调用成功后数据返回给医生站进行保存。
2、审核医嘱后:	自动调用预核验->生成处方Base64信息->签名->上传(发起点:见下方CheckPrescPrint)
3、撤销医嘱前:	获取所有待停止医嘱		##class(web.DHCOEOrdItem).GetOrdList
				判断处方是否已经审核	##class(web.DHCDocInPatPortalCommon).CheckMulOrdDealPermission
4、撤销医嘱后:	自动调用撤销(发起点:见下方CheckPrescUndo)
5、相关方法调试
	接口对照类: DHCDoc.Interface.Inside.InsuPresc.Relate.cls
	**********调试任一接口前,务必确保此文件所有方法均可正确返回**********
	关联HIS类: DHCDoc.Interface.Inside.InsuPresc.Order.cls
	  (1)判断是否进行电子处方上传: CheckIsUpldByOrder
	  (2)打印模板赋值: GetPrintInfoByPrescNo
	  (3)保存处方流转数据: SavePrescBaseData
	     表名: DOC.Interface.PrescBase.cls
	处方上传XML模板: DHCOutPrescXYYBCFZX
6、目前查询界面没有集成，需要单独部署
*/
$(function(){
	if (typeof Common_ControlObj!="object") return;
	if (typeof Common_ControlObj.InterfaceArr!="object") return;
	//
	var DROutPrescObj = {
		Name:"DongRuan_OutPresc",
		OEOrd:{
			//医嘱录入-审核后
			AfterUpdate:function(EpisodeID,OEOrdItemIDs) {
				OutPrescFuncs.CheckPrescPrint(EpisodeID,OEOrdItemIDs);
			}
		},
		CMOEOrd:{
			//中草药录入-审核后
			AfterUpdate:function(EpisodeID,OEOrdItemIDs) {
				//OutPrescFuncs.CheckPrescPrint(EpisodeID,OEOrdItemIDs);
			}
		},
		Funcs:{
			//停医嘱
			CheckPrescUndo:function(EpisodeID,OrdList) {
				OutPrescFuncs.CheckPrescUndo(EpisodeID,OrdList);
			},
			//电子处方信息查询
			hospRxDetlQuery:function(EpisodeID,PrescNo) {
				OutPrescFuncs.hospRxDetlQuery(EpisodeID,PrescNo);
			},
			//电子处方审核结果查询
			rxChkInfoQuery:function(EpisodeID,PrescNo) {
				OutPrescFuncs.rxChkInfoQuery(EpisodeID,PrescNo);
			},
			//电子处方取药结果查询
			rxSetlInfoQuery:function(EpisodeID,PrescNo) {
				OutPrescFuncs.rxSetlInfoQuery(EpisodeID,PrescNo);
			}
		}
	}
	Common_ControlObj.InterfaceArr.push(DROutPrescObj);
	//
	var OutPrescFuncs={
		LoginInfo: session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.HOSPID'],
		CheckPrescPrint: function(EpisodeID,OEOrdItemIDs) {
			try{
				$.cm({
					ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
					MethodName:"GetPrescStrByOrdList",
					dataType:"text",
					OrderStr:OEOrdItemIDs
				},function(PrescStr){
					if (PrescStr=="") return;
					var PrescArr=PrescStr.split("^");
					for (var i = 0; i < PrescArr.length; i++) {
						var PrescNo=PrescArr[i];
						var Obj = {
							"EpisodeID":EpisodeID,
							"PrescNo":PrescNo,
							"UpldFlag":"Y"
						}
						OutPrescObj.uploadChk(Obj);
					}
				})
			}catch(e){
				dhcsys_alert("电子处方上传异常:"+e.message);
			}
	    },
	    //预核验
		uploadChk: function(Obj) {
	        $.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"uploadChk",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("提示",Obj.PrescNo+" 预核验失败:"+rtn.split("^")[1]);
					return false;
				}
				OutPrescObj.CreatePDFBase64(Obj);
			})
	    },
	    //生成Base64值
		CreatePDFBase64: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"GetPrintInfoByPrescNo",
				dataType:"text",
				EpisodeID:Obj.EpisodeID,PrescNo:Obj.PrescNo
			},function(JsonStr){
				if (JsonStr=="") {
					$.messager.alert("提示",Obj.PrescNo+" "+"获取打印数据失败");
					OutPrescObj.LoadOrderListTab();
					return false;
				}
				var PrtObj = eval('(' + JsonStr + ')');
				var PrtXML = OutPrescObj.GetPrintXmlFromObj(PrtObj);
				//调用基础平台接口,生成数据
				DHC_PrintByLodop("",PrtXML.MyPara,PrtXML.MyList,[],"DHCOutPrescXYYBCFZX",{
					printListByText: true,
					windowCloseOnBase64: true,
					onCreatePDFBase64: function(Base64Str) {
						if (Base64Str == "") {
							$.messager.alert("提示",Obj.PrescNo+" "+"未生成处方Base64编码,无法上传!");
							OutPrescObj.LoadOrderListTab();
							return false;
						}
						$.cm({
							ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
							MethodName:"SaveBase64",
							dataType:"text",
							PrescNo:Obj.PrescNo,Base64Str:Base64Str
						},function(rtn){
							if (rtn.split("^")[0]!="0") {
								$.messager.alert("提示",Obj.PrescNo+" "+rtn.split("^")[1]);
								OutPrescObj.LoadOrderListTab();
								return false;
							}
							OutPrescObj.rxFixmedinsSign(Obj);
						}) 
					}
				});
			})
		},
		//电子处方医保电子签名
		rxFixmedinsSign: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxFixmedinsSign",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("提示",Obj.PrescNo+" 签名失败:"+rtn.split("^")[1]);
					OutPrescObj.LoadOrderListTab();
					return false;
				}
				if (Obj.UpldFlag=="Y") {
					OutPrescObj.rxFileUpld(Obj);
				}
			})
		},
		//电子处方上传
		rxFileUpld: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxFileUpld",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("提示",Obj.PrescNo+" 上传失败:"+rtn.split("^")[1]);
					OutPrescObj.LoadOrderListTab();
					return false;
				}
				$.messager.show({title:"提示",msg:Obj.PrescNo+" "+"电子处方上传成功!"});
				OutPrescObj.LoadOrderListTab();
			})
		},
		//电子处方撤销
		CheckPrescUndo: function(EpisodeID,OrdList) {
			try{
				$.cm({
					ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
					MethodName:"GetPrescOrdListByStop",
					dataType:"text",
					EpisodeID:EpisodeID,OrderStr:OrdList
				},function(PrescOrdList){
					var SuccPrescStr=PrescOrdList.split("###")[1];
					if (SuccPrescStr=="") return;
					var PrescArr=SuccPrescStr.split("^");
					for (var i = 0; i < PrescArr.length; i++) {
						var PrescNo=PrescArr[i];
						var Obj = {
							"EpisodeID": EpisodeID,
							"PrescNo": PrescNo,
						};
						OutPrescObj.rxUndo(Obj);
					}
				})
			}catch(e){
				dhcsys_alert("电子处方撤销异常:"+e.message);
			}
	    },
		rxUndo: function(Obj) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxUndo",EpisodeID:Obj.EpisodeID,
				PrescNo:Obj.PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("提示",Obj.PrescNo+" 撤销失败:"+rtn.split("^")[1]);
					return false;
				}
				$.messager.show({title:"提示",msg:Obj.PrescNo+" "+"电子处方撤销成功!"});
				OutPrescObj.LoadOrderListTab();
			})
		},
		//电子处方信息查询
		hospRxDetlQuery: function(EpisodeID,PrescNo) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"hospRxDetlQuery",EpisodeID:EpisodeID,
				PrescNo:PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("提示",PrescNo+" "+rtn.split("^")[1]);
					return false;
				}
				$.messager.alert("提示",PrescNo+" "+"信息查询成功:<br>"+rtn.split("^")[1]).window({width:1000,left:300});
			})
		},
		//电子处方审核结果查询
		rxChkInfoQuery: function(EpisodeID,PrescNo) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxChkInfoQuery",EpisodeID:EpisodeID,
				PrescNo:PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("提示",PrescNo+" "+rtn.split("^")[1]);
					return false;
				}
				$.messager.alert("提示",PrescNo+" "+"审核结果查询成功:<br>"+rtn.split("^")[1]).window({width:1000,left:300});
			})
		},
		//电子处方取药结果查询
		rxSetlInfoQuery: function(EpisodeID,PrescNo) {
			$.cm({
				ClassName:"DHCDoc.Interface.Inside.InsuPresc.Order",
				MethodName:"SavePrescBaseData",
				dataType:"text",
				InvokeType:"rxSetlInfoQuery",EpisodeID:EpisodeID,
				PrescNo:PrescNo,ExpStr:OutPrescObj.LoginInfo
			},function(rtn){
				if (rtn.split("^")[0]!="0") {
					$.messager.alert("提示",PrescNo+" "+rtn.split("^")[1]);
					return false;
				}
				$.messager.alert("提示",PrescNo+" "+"取药结果查询成功:<br>"+rtn.split("^")[1]).window({width:1000,left:300});
			})
		},
		//刷新界面
		LoadOrderListTab: function() {
	        if (typeof LoadOrderListTabDataGrid == "function") {
	            LoadOrderListTabDataGrid()
	        }
		},
		//处方预览(基础平台接口)
		getPdf: function(PrescNo,Type) {
			try{
				/**
				 * 根据base64的字符串，打开PDF文件预览，可看，可下载，可打印。
				 * @param {*} base64Str 注意要是有头的字符串，即：data:application/pdf;base64,JVBEXXXXX...
				 */
				var base64Str=tkMakeServerCall("DHCDoc.Interface.Inside.InsuPresc.Order","GetPrescBase64",PrescNo,Type);
				if (base64Str=="") {
					$.messager.alert("提示",PrescNo+" 未查询到对应的base64数据");
					return false;
				}
				if (base64Str.indexOf("data:application/pdf;base64")==-1) {
					base64Str="data:application/pdf;base64,"+base64Str;
				}
				//根据文件的所在路径修正
				var href = '../scripts_lib/pdfjs-base64ToPDF/web/viewer.html';	
				window["base64String"] = base64Str;
				window.open(href, "pdf");
			}catch(e){
				dhcsys_alert("电子处方预览异常:"+e.message);
			}
		},
	    //解析对象数据为xml打印需要的格式
		GetPrintXmlFromObj: function(PrintObj) {
	        var PInpara = "";
	        var PInlist = "";
	        for (var id in PrintObj) {
	            if (id == "MyList") {
	                PInlist = PrintObj[id];
	            } else {
	                if (PInpara == "") {
	                    PInpara = id + String.fromCharCode(2) + PrintObj[id]
	                } else {
	                    PInpara += "^" + id + String.fromCharCode(2) + PrintObj[id]
	                }
	            }
	        }
	        var PrintXml = {
	            MyPara: PInpara,
	            MyList: PInlist
	        }
	        return PrintXml;
	    }
	}
})
