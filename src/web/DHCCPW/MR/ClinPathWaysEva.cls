/// 名称: web.DHCCPW.MR.ClinPathWaysEva
/// 描述: 路径实施评估记录的展现、保存与提取
/// 编写者：wuqk
/// 编写日期: 2011-09-26
Class web.DHCCPW.MR.ClinPathWaysEva Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCCPW.MR.ClinPathWaysEva).GetEvaElements(89)
ClassMethod GetEvaElements(PathWayID As %String) As %String
{
	new (PathWayID)
	set ret="var subelements=[];var panelheight=100;"
	
	Set $ZT="GetEvaElementsErr"
	Set cPathWayID=""
	Set objPathWay=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
	If $IsObject(objPathWay) {
		If $IsObject(objPathWay.CPWPathwayDR) {
			set cPathWayID=objPathWay.CPWPathwayDR.%Id()
		}
		Set RstID=$o(^DHCMR("CPW",PathWayID,"RST",""),-1)
		If RstID'="" {
			Set objPathWayRst=##class(web.DHCCPW.MR.ClinPathWaysResult).GetObjById(PathWayID_"||"_RstID)
			If $IsObject(objPathWayRst)
			{
				Set listPathWayRst=objPathWayRst.CPWREvaluations
				For indPathWayRst=1:1:$listlength(listPathWayRst)
				{
					Set itmPathWayRst=$listget(listPathWayRst,indPathWayRst)
					Set itmKey=$p(itmPathWayRst,":",1)
					Continue:itmKey=""
					Set itmValue=$p(itmPathWayRst,":",2)
					//统一日期格式 add by mxp 20170330
					set objSubCate=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(itmKey)
					continue:'$IsObject(objSubCate)
					if (objSubCate.BDSCType="D") {
						Set:itmValue'="" itmValue=##class(DHCMed.SSService.CommonCls).DateLogicalToHtml(itmValue)
					}
					Set arrPathWayRst(itmKey)=itmValue
				}
			}
		}
	}
	quit:cPathWayID="" ret
	set subCateList=##Class(web.DHCCPW.MRC.ClinPathWaysSrv).GetEvaluateListById(cPathWayID)
	quit:subCateList="" ret
	set len=$l(subCateList,"^")
	set elementsCount=0
	set eleString=""
	for i=1:1:len {
		set subCateRowId=$p(subCateList,"^",i)
		continue:subCateRowId=""
		set unique=+$p(subCateRowId,":",2)    //是否必填项目
		set subCateRowId=$p(subCateRowId,":",1)
		set objSubCate=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(subCateRowId)
		continue:'$IsObject(objSubCate)
		set element=""
		if objSubCate.BDSCType="DIC"{
			//"web.DHCCPW.MRC.BaseDictionary","QryDicBySubCatDesc" //BD_RowId,BD_Code,BD_Desc
			Set result = ##class(%ResultSet).%New("web.DHCCPW.MRC.BaseDictionary:QryDicBySubCatDesc")
			Do result.Execute(objSubCate.BDSCCode,"Y")
			set data=""
			While (result.Next()) {
			     set data=data_"['"_result.Data("BD_RowId")_"','"_result.Data("BD_Desc")_"'],"
			}
			if data="" {set data="[]"}
			else {set data=$e(data,1,$l(data)-1),data="["_data_"]"}
			if objSubCate.BDSCMultiSelect{
				set element="new Ext.ux.form.LovCombo({"
				//set element=element_"id : '"_objSubCate.BDSCCode_"_"_subCateRowId_"',"
				set element=element_"hiddenName : '"_subCateRowId_"',"
				set:unique element=element_"allowBlank:false,"
				set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
				set element=element_"mode: 'local',"
				set element=element_"fieldLabel:'"_objSubCate.BDSCDesc_"',"
				set element=element_"hideOnSelect:false,"
				set element=element_"maxHeight:200,triggerAction:'all',"
				set element=element_"store:new Ext.data.ArrayStore({id: 0,fields:['id','Text'],data:"_data_"}),"
				set element=element_"anchor:'95%',valueField:'id',displayField:'Text'"   //,hiddenName:'"_subCateRowId_"'
				set element=element_"})"
			}
			else{
				set element="{xtype:'combo',"
				set element=element_"hiddenName:'"_subCateRowId_"',"
				set:unique element=element_"allowBlank:false,"
				set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
				set element=element_"mode: 'local',"
				set element=element_"fieldLabel:'"_objSubCate.BDSCDesc_"',"
				set element=element_"triggerAction:'all',"
				set element=element_"forceSelection:true,"
				set element=element_"store: new Ext.data.ArrayStore({fields:['id','Text'],data:"_data_"}),"
				//set element=element_"valueField:'id',displayField:'Text',hiddenName:'"_subCateRowId_"',hiddenValue:'id'"
				set element=element_"anchor:'95%',valueField:'id',displayField:'Text'"
				set element=element_"}"
				
				/*
				id : 'cboType',
			    mode: 'local',
			    fieldLabel : '数据类型',
			    forceSelection:true,
			    allowBlank : false,
			    store: new Ext.data.ArrayStore({id: 0,fields:['id','Text'],data: data}),
			    valueField: 'id',displayField: 'Text'
				*/
			}
		}
		elseif objSubCate.BDSCType="B"{  //checkbox			
			set element="{xtype:'checkbox',"
			set element=element_"id:'"_subCateRowId_"',"
			set:$g(arrPathWayRst(subCateRowId))="on" element=element_"checked:true,"
			set element=element_"fieldLabel:'"_objSubCate.BDSCDesc_"'"
			set element=element_"}"
			/*
			id : 'txtIsActive'
			,fieldLabel : '是否有效'
			,disabled : true
			,width : 100
			,anchor : '95%'
			*/
		}
		elseif objSubCate.BDSCType="T"{	 //textfield
			set element="{xtype:'textfield',"
			set element=element_"id:'"_subCateRowId_"',"
			set:unique element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"anchor:'95%',fieldLabel:'"_objSubCate.BDSCDesc_"'"
			set element=element_"}"
			
			/*
			id : 'txtPathType'
			,fieldLabel : '路径类型'
			,disabled : true
			,width : 100
			,anchor : '95%'
			*/
		}
		elseif objSubCate.BDSCType="D"{  //datefield
			set element="{xtype:'datefield',"
			set element=element_"id:'"_subCateRowId_"',"
			set:unique element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"fieldLabel:'"_objSubCate.BDSCDesc_"',"
			set element=element_"anchor:'95%',format : ((typeof websys_DateFormat == 'undefined')?'Y-m-d':websys_DateFormat)"
			set element=element_"}"
			/*
			id : 'dtFrom'
			,format : 'Y-m-d'
			,width : 100
			,fieldLabel : '生效日期'
			,anchor : '99%'
			,altFormats : 'Y-m-d|d/m/Y'
			*/
		}
		elseif objSubCate.BDSCType="I"{  //numberfield
			set element="{xtype:'numberfield',"
			set element=element_"id:'"_subCateRowId_"',"
			set:unique element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"fieldLabel:'"_objSubCate.BDSCDesc_"',"
			set element=element_"anchor:'95%',allowDecimals:false"
			set element=element_"}"		
			/*
			id : 'PathWayEpnum'
			,width : 100
			,anchor : '99%'
			,fieldLabel : '阶段序号'
			,allowDecimals:false
			,nanText : '只允许输入整数!'
			*/
		}
		elseif objSubCate.BDSCType="N"{  //numberfield
			set element="{xtype:'numberfield',"
			set element=element_"id:'"_subCateRowId_"',"
			set:unique element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"fieldLabel:'"_objSubCate.BDSCDesc_"',"
			set element=element_"anchor:'95%',allowDecimals:true"
			set element=element_"}"
		}
		kill arrPathWayRst(subCateRowId)
		set:element'="" eleString=eleString_element_",",elementsCount=elementsCount+1
	}
	
	//*******************************
	//add by zf 20120330
	set subCateRowId=0
	for {
		set subCateRowId=$o(arrPathWayRst(subCateRowId))
		quit:subCateRowId=""
		set objSubCate=##class(web.DHCCPW.MRC.BaseDicSubCategory).GetObjById(subCateRowId)
		continue:'$IsObject(objSubCate)
		set element=""
		if objSubCate.BDSCType="DIC"{
			//"web.DHCCPW.MRC.BaseDictionary","QryDicBySubCatDesc" //BD_RowId,BD_Code,BD_Desc
			Set result = ##class(%ResultSet).%New("web.DHCCPW.MRC.BaseDictionary:QryDicBySubCatDesc")
			Do result.Execute(objSubCate.BDSCCode,"Y")
			set data=""
			While (result.Next()) {
			     set data=data_"['"_result.Data("BD_RowId")_"','"_result.Data("BD_Desc")_"'],"
			}
			if data="" {set data="[]"}
			else {set data=$e(data,1,$l(data)-1),data="["_data_"]"}
			if objSubCate.BDSCMultiSelect{
				set element="new Ext.ux.form.LovCombo({"
				//set element=element_"id : '"_objSubCate.BDSCCode_"_"_subCateRowId_"',"
				set element=element_"hiddenName : '"_subCateRowId_"',"
				set element=element_"allowBlank:false,"
				set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
				set element=element_"mode: 'local',"
				set element=element_"fieldLabel:'*"_objSubCate.BDSCDesc_"',"
				set element=element_"hideOnSelect:false,"
				set element=element_"maxHeight:200,triggerAction:'all',"
				set element=element_"store:new Ext.data.ArrayStore({id: 0,fields:['id','Text'],data:"_data_"}),"
				set element=element_"anchor:'95%',valueField:'id',displayField:'Text'"   //,hiddenName:'"_subCateRowId_"'
				set element=element_"})"
			}
			else{
				set element="{xtype:'combo',"
				set element=element_"hiddenName:'"_subCateRowId_"',"
				set element=element_"allowBlank:false,"
				set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
				set element=element_"mode: 'local',"
				set element=element_"fieldLabel:'*"_objSubCate.BDSCDesc_"',"
				set element=element_"triggerAction:'all',"
				set element=element_"forceSelection:true,"
				set element=element_"store: new Ext.data.ArrayStore({fields:['id','Text'],data:"_data_"}),"
				//set element=element_"valueField:'id',displayField:'Text',hiddenName:'"_subCateRowId_"',hiddenValue:'id'"
				set element=element_"anchor:'95%',valueField:'id',displayField:'Text'"
				set element=element_"}"
				
				/*
				id : 'cboType',
			    mode: 'local',
			    fieldLabel : '数据类型',
			    forceSelection:true,
			    allowBlank : false,
			    store: new Ext.data.ArrayStore({id: 0,fields:['id','Text'],data: data}),
			    valueField: 'id',displayField: 'Text'
				*/
			}
		}
		elseif objSubCate.BDSCType="B"{  //checkbox			
			set element="{xtype:'checkbox',"
			set element=element_"id:'"_subCateRowId_"',"
			set element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))="on" element=element_"checked:true,"
			set element=element_"fieldLabel:'*"_objSubCate.BDSCDesc_"'"
			set element=element_"}"
			/*
			id : 'txtIsActive'
			,fieldLabel : '是否有效'
			,disabled : true
			,width : 100
			,anchor : '95%'
			*/
		}
		elseif objSubCate.BDSCType="T"{	 //textfield
			set element="{xtype:'textfield',"
			set element=element_"id:'"_subCateRowId_"',"
			set element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"anchor:'95%',fieldLabel:'*"_objSubCate.BDSCDesc_"'"
			set element=element_"}"
			
			/*
			id : 'txtPathType'
			,fieldLabel : '路径类型'
			,disabled : true
			,width : 100
			,anchor : '95%'
			*/
		}
		elseif objSubCate.BDSCType="D"{  //datefield
			set element="{xtype:'datefield',"
			set element=element_"id:'"_subCateRowId_"',"
			set element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"fieldLabel:'*"_objSubCate.BDSCDesc_"',"
			set element=element_"anchor:'95%',format : ((typeof websys_DateFormat == 'undefined')?'Y-m-d':websys_DateFormat)"
			set element=element_"}"
			/*
			id : 'dtFrom'
			,format : 'Y-m-d'
			,width : 100
			,fieldLabel : '生效日期'
			,anchor : '99%'
			,altFormats : 'Y-m-d|d/m/Y'
			*/
		}
		elseif objSubCate.BDSCType="I"{  //numberfield
			set element="{xtype:'numberfield',"
			set element=element_"id:'"_subCateRowId_"',"
			set element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"fieldLabel:'*"_objSubCate.BDSCDesc_"',"
			set element=element_"anchor:'95%',allowDecimals:false"
			set element=element_"}"		
			/*
			id : 'PathWayEpnum'
			,width : 100
			,anchor : '99%'
			,fieldLabel : '阶段序号'
			,allowDecimals:false
			,nanText : '只允许输入整数!'
			*/
		}
		elseif objSubCate.BDSCType="N"{  //numberfield
			set element="{xtype:'numberfield',"
			set element=element_"id:'"_subCateRowId_"',"
			set element=element_"allowBlank:false,"
			set:$g(arrPathWayRst(subCateRowId))'="" element=element_"value:'"_$g(arrPathWayRst(subCateRowId))_"',"
			set element=element_"fieldLabel:'*"_objSubCate.BDSCDesc_"',"
			set element=element_"anchor:'95%',allowDecimals:true"
			set element=element_"}"
		}
		kill arrPathWayRst(subCateRowId)
		set:element'="" eleString=eleString_element_",",elementsCount=elementsCount+1
	}
	//*******************************
	
	set:eleString'="" eleString=$e(eleString,1,$l(eleString)-1)
	set panelheight=elementsCount*40+60
	Set:panelheight>450 panelheight=450
	set ret="var subelements=["_eleString_"];var panelheight="_panelheight_";"
	
	quit ret
GetEvaElementsErr
	set ret="var subelements=[];var panelheight=100;"
	quit ret
}

}
