/// 表单布局表
/// zhouxin
/// 2017-09-20
Class User.DHCAdvForm Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvForm ]
{

// 表单名称

Property formName As User.DHCAdvFormName;

// 表单字典表

Property formDic As User.DHCAdvFormDic;

// 父节点id

Property parRef As %String [ InitialExpression = 0 ];

// 行类型 

// row 行元素

// column 列元素

// element 表单元素

Property rowType As %String;

// 行样式 

Property rowStyle As %String;

// 当前版本

Property version As %String;

Storage Default
{
<Data name="DHCAdvFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>formName</Value>
</Value>
<Value name="3">
<Value>panel</Value>
</Value>
<Value name="4">
<Value>formDic</Value>
</Value>
<Value name="5">
<Value>parRef</Value>
</Value>
<Value name="6">
<Value>rowNum</Value>
</Value>
<Value name="7">
<Value>rowType</Value>
</Value>
<Value name="8">
<Value>rowStyle</Value>
</Value>
<Value name="9">
<Value>version</Value>
</Value>
<Value name="10">
<Value>formName</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvFormD</DataLocation>
<DefaultData>DHCAdvFormDefaultData</DefaultData>
<IdLocation>^User.DHCAdvFormD</IdLocation>
<IndexLocation>^User.DHCAdvFormI</IndexLocation>
<StreamLocation>^User.DHCAdvFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// d ##class(User.DHCAdvForm).%BuildIndices($ListBuild("IndexNameVersionParef"))
Index IndexNameVersionParef On (formName, version, parRef);

/// d ##class(User.DHCAdvForm).%BuildIndices($ListBuild("IndexNameVersion"))
Index IndexNameVersion On (formName, version As AlphaUp);

/// d ##class(User.DHCAdvForm).%BuildIndices($ListBuild("IndexDic"))
Index IndexDic On (formName, version, formDic As AlphaUp);

/// 	
/// 输出布局样式
/// zhouxin
/// 2017-09-27
Method ToLayoutHtml(recordId = "", inplist = "", HospId = "")
{
	s advpid=$i(^CacheTemp) //hxy  2017-11-28
	s type=..rowType
	s inpflag=$p(inplist,"^",1)
	s inpstaus=$p(inplist,"^",2)
	i (type="column")||(type="row") {
		w "<div class='"_..rowStyle_"'>"
			s checkPanel=""
			i $ISOBJECT(..formName) d
			.s checkPanel=..checkPanel(..formName.%Id(),..%Id(),..version)
			s panelTitle=$p(checkPanel,"^",1)
			s panelTitle=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",panelTitle)  ;2020-06-28 cy
			s dicKey=$p(checkPanel,"^",3)
			s tmpStyle=$p(checkPanel,"^",4)
			i panelTitle'=0 d
			.// panel
			.i tmpStyle="panel" d
			..w "<div class='dhcc-panel' style='width:99.8%' id="_dicKey_"> "
			..w "	 <div class='dhcc-panel-header'><div class='dhcc-panel-title'>"_panelTitle
			..;w "	 <img src='../scripts/dhcadvEvt/images/titleMsg.png' class='dhcc-panel-titleimg'></img></div></div>"   ;2018-11-09 cy  修改panel提示文字
			..w "	 <img src='../scripts/dhcadvEvt/images/titleMsg.png' class='dhcc-panel-titleimg' title='"_panelTitle_"' position= 'top'></img></div></div>"  ;2018-11-09 cy  修改panel提示文字
  	 		..w "    <div class='dhcc-panel-body' style='padding-left:10px'>"
  	 		..s panel=dicKey_"^"_panelTitle ;hxy 2017-11-28
  	 		..s ^TMP("DHCADV","User.DHCAdvForm","ToLayoutHtml",advpid)=panel  ;hxy 2017-11-28
			.// fieldset
			.i tmpStyle="fieldset" d
			..w "<fieldset id="_dicKey_">"
			..w "<legend ondblclick='dbClickLegend(this)' >"_panelTitle_"</legend>"
			s subform=""
			f  s subform=$o(^User.DHCAdvFormI("IndexNameVersionParef",..formName.%Id()," "_..version," "_..%Id(),subform)) q:subform=""  d
			.s formObj=##class(User.DHCAdvForm).%OpenId(subform)
			.i ($ISOBJECT(formObj)) d
			..d formObj.ToLayoutHtml(recordId,inplist,HospId)
			
			i panelTitle'=0 d
			.i tmpStyle="panel" d
			..w "</div>"
			..w "</div>"
			.i tmpStyle="fieldset" d
			..w "</fieldset>"
			.i tmpStyle="panel" d
			
			..s editflag=0
			..s:inpflag="Y" editflag=##class(web.DHCADVCOMMONPART).ChkFormDic(dicKey,inpstaus,HospId)
			..i (editflag=1)||(inpflag="N")  d
			...w "<script>SetPanel('"_dicKey_"')</script>"
			
		w "</div>"
		
		//同级select-change特殊处理	
		i (type="row") {
			s ret=0
			s ret=##class(User.DHCADVFormHelp).checkSameLevel(..formName.%Id(),..%Id(),..version)
			i (ret'=0){
				
				w "<div class='row'><div class='col-md-12' id='"_$p(ret,"^",2)_"-"_$p(ret,"^",1)_"'>"
				d ..WriteCommonItm($p(ret,"^",2),$p(ret,"^",1),recordId,"select-change")
				w "</div></div>"
			}
		}
	
	}
	
	i type="element"{

			s style=..formDic.style
			i (style'="panel")&&(style'="fieldset"){	
				//w "<div class='row'><div class='col-md-12'>"  ;2018-03-30 布局一行加样式调整
				i ($ISOBJECT(..formDic)){
					d ..ToElementHtml(..formDic.%Id(),..%Id(),recordId)
				}
				//w "</div></div>"  ;2018-03-30 布局一行加样式调整
			}	 
	}
}

/// 输出元素
ClassMethod ToElementHtml(id, formid, recordId = "", width = "100%", dialayFlag = "")
{
	n (%session)
	//w recordId,!
	q:'$d(^User.DHCAdvFormDicD(id))
	s dicData=^User.DHCAdvFormDicD(id)
	s style=$LIST(dicData,3)
	s dicField=$LIST(dicData,2)
	s field=formid_"."_id
	
	s url=$LIST(dicData,5)
	s title=$LIST(dicData,4)
	s title=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",title)  ;2020-06-28 cy
	s fieldlable="lable"_dicField
	s newLine=$LIST(dicData,8)
	s parref=+$LIST(dicData,6)
	s parrefDicField=""
	s:parref'=0 parrefDicField=$LISTGET(^User.DHCAdvFormDicD(parref),2)
	s value=$LIST(dicData,7)
	s dicWidth=$LIST(dicData,10)
	s dicHeight=$LIST(dicData,11)
	s cols=$LIST(dicData,12)
	s rows=$LIST(dicData,13)
	s sameLevel=$LIST(dicData,15)
	s hiddenValue=$LIST(dicData,16)
	s hiddenSub=$LIST(dicData,17)
	//子元素与父元素同行显示，支持父元素是label子元素是radio和checkbox
	s subDicSameLine=$LISTGET(dicData,18)
	//是否输出input的title
	s displayTitle=$LISTGET(dicData,20)
	//元素是否隐藏 cy 2019-11-21
	s hiddenDic=$LISTGET(dicData,23) 
	//子元素与父元素换行显示，支持父元素是label子元素是radio和checkbox
	s subDicTile=$LISTGET(dicData,24) //hxy 2018-06-06 子元素平铺
	s dicWidth=$case(dicWidth,"":130,:dicWidth)
	s dicHeight=$case(dicHeight,"":30,:dicHeight)
	s lable="lable-input"
	s inputLable="easyui-datebox  radio-date"
	s requried=""
	s attrStyle=""
	s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",formid,id,""))
	i attr'=0 d
	.s attrStr=$LISTTOSTRING(^User.DHCADVFormAttrD(attr),"^",1)
	.s:$p(attrStr,"^",4)="on" requried="Y"
	.s attrStyle=$p(attrStr,"^",8)	
	s text=""
	q:hiddenDic="Y" //元素是否隐藏 cy 2019-11-21

	
	i (style="form"){
		
		d ##class(web.DHCADVForm).displayForm(value,recordId,1) 
	}
	i "Y"=newLine {
		w "<div style='height:1px'></div> "
	}
	//查询已经填写过的记录
	i recordId'="" d
	.s value=""
	.s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,id,""))
	.i recordItmId'=0 d
	..s value=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)
	..S:(value["-")&&($L(value)="10")&&($L(value,"-")="3") value=##class(web.DHCADVCOMMONPART).GetDateToHtml(value)  //2018 cy
	..s text=value
	
	i (style="label")&&(subDicSameLine="Y"){
		
	
	
		w "<label id='"_dicField_"' " 	
		i requried="Y"{
			w "data-requried='Y'"
			w "style='display:inline-block;width:100%;"_attrStyle_"'"	
		}
		w " >"
		w "</label>"   /// 2021-11-23 cy 添加 此处添加label 解决 设置同行显示的数据，第一层子元素设置隐藏子元素（第二、洒三层），界面勾选显示后，点击空白处会触发元素的勾选事件的问题
		w "<label style='margin: 0px;padding: 0px;display:inline-block;min-height:32px;"_attrStyle_"' >"  ;2018-03-30 布局一行加样式调整 2021-07-27 cy height改为 min-height 不固定label高度，容易出现重叠现象
		w title
		i requried="Y"{
			w "<em class='dhc-required' >*</em>"	
		}
		
		w "：&nbsp;&nbsp;&nbsp;&nbsp;"
		w "</label>"
		
		i hiddenSub'="Y" d
		.;s itm=""
		.;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
		.;.d ..ToElementHtml(itm, formid, recordId , 0)	
		.s seq=""  /// 2021-02-04 cy 索引替换， 顺序号起作用
		.f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
		..s itm=""
		..f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
		...d ..ToElementHtml(itm, formid, recordId,0)
		;w "</label>"   /// 2021-11-23 cy 注释 此处添加label会导致 设置同行显示的数据，第一层子元素设置隐藏子元素（第二、洒三层），界面勾选显示后，点击空白处会触发元素的勾选事件的问题

	}
	
	//hxy 2018-06-06 换行平铺 st
	i (style="label")&&(subDicTile="Y")&&(subDicSameLine'="Y"){ //防止重复
		
		w "<div id='"_dicField_"' " 	
		i requried="Y"{
			w "data-requried='Y'"
			w "style='display:inline-block;width:100%;"_attrStyle_"'"	
		}
		w " >"
		
		w "<label style='margin: 0px;padding: 0px;display:inline-block;min-height:32px;"_attrStyle_"' >"  ;2018-03-30 布局一行加样式调整 2021-07-27 cy height改为 min-height 不固定label高度，容易出现重叠现象
		w title
		i requried="Y"{
			w "<em class='dhc-required' >*</em>"	
		}
		w "</label>"
		w "<div style='padding-left:20px;font-weight:normal'>"
		i hiddenSub'="Y" d
		.;s itm=""
		.;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
		.;.d ..ToElementHtml(itm, formid, recordId , 0)
		.s seq=""  /// 2021-02-04 cy 索引替换， 顺序号起作用
		.f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
		..s itm=""
		..f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
		...d ..ToElementHtml(itm, formid, recordId,0)
		
			
		w "</div>"
		w "</div>"

	} //hxy 2018-06-06 换行平铺 ed

	
	q:(subDicSameLine="Y")&&(style="label")
	q:(subDicTile="Y")&&(style="label") //hxy 2018-06-06 换行平铺
	i (style="img"){  
	   ;s imgurl="../scripts/dhcadvEvt/images/LocaPic.jpg"
	   w "<label><img src="_url_"  width='"_dicWidth_"' height='"_dicHeight_"' ></label>"
     }
	i (style="upload"){
		w title
		s ftpIp=##class(web.DHCADVFormUploadPic).GetFtpIp()
		w "<div id='picViewDiv'>"
		i value'="" d
		.s imgurl="'http://"_ftpIp_"/ftpsci/"_value_"'"
		.w "<img src="_imgurl_"  width='150px' height='150px' onClick='viewPic(this)' data-id="_imgurl_"><a class='easyui-linkbutton' data-options=""iconCls:'icon-remove',plain:true"" onclick='javascript:removePic()'>"_##class(websys.Translation).Get("dhcadv.layoutform.csp","删除")_"</a>"
		w "</div>"
		
		//ie 8 以上有flash用以下代码
		w "<input type='file' name='file_upload' id='file_upload' />"
		w "<input type='hidden' name="_field_" id='picPath'>"
		//ie 8 用以下代码
		//w "<form enctype='multipart/form-data' method='post' action='dhcadv.upload.csp?act=upload' target='disIframe'>"
		//w "<input type=file size=30 name=files   multiple>"
		//w "<input type='submit' value='上传'>"					
		//w "</form>"
		//w "<iframe style='display: none' id='disIframe' name='disIframe'></iframe>"
	}  
	i ((style="popModel")||(style="tab")||(style="label")||(style="datagrid")||(style="table")){
		w "<label id='"_dicField_"' " 
		i requried="Y"{
			w "data-requried='Y'"
		}
		//样式开始
		w "style='display:inline-block;"_attrStyle_""
		i style="label" d
		.i (dialayFlag'="Y")&&(parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d   ;2021-06-09 cy 父元素-子元素隐藏与显示
		..w ";display:none;"
		w "'"
		//样式结束
		w " data-parref='"_parrefDicField_"'"
		w " >"
		
		w title
		i requried="Y"{
			w "<em class='dhc-required' >*</em>"	
		}
		w "</label>"
		i (style="popModel"){
			w "&nbsp;&nbsp;&nbsp;&nbsp;<button class='placeBut' onClick='popModel("_id_","_formid_","""_title_""");'>点击选择</button>"
		}
		i "Y"=$LISTGET(^User.DHCAdvFormDicD(id),19) d
		.w "<a class='easyui-linkbutton' data-options=""iconCls:'icon-add',plain:true"" onclick='javascript:addRow(this,"_id_","_formid_")' >"_##class(websys.Translation).Get("dhcadv.layoutform.csp","增加")_"</a>"

	}
	
	i (style="button"){
		w "<a id='"_dicField_"' href='#' class='easyui-linkbutton'  style='"_attrStyle_"' >"_title_"</a> "	
	}
	i ((style="select-change")||(style="easyui-datetimebox")||(style="easyui-datebox")||(style="easyui-validatebox")||(style="input")||(style="easyui-combobox")) 
	{
		
		s selectChangeLabel=""
		i parref'=0 d
		.w "<label style='"_attrStyle_"' >"	
		.w "<label data-parref='"_parrefDicField_"' style='"
		.; 2021-06-09 cy 子元素隐藏与显示
		.i (dialayFlag'="Y")&&(parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
		..i ((recordId="")||(((recordId'="")&&'$d(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,+parref)))))  d
		...w "display:none;"
		.w "'>"_title_"</label>"  ;2019-12-31 cy input元素 标题用label标签包含
		.;w title_"&nbsp;&nbsp;&nbsp;&nbsp;" ;2019-12-31 cy input元素 标题用label标签包含
		e  i displayTitle="Y" d
		.w title_"&nbsp;&nbsp;&nbsp;&nbsp;"
		
		i ($$ALPHAUP^SSUTIL4(url)="")&&(style="easyui-combobox"){
			w "<select class='easyui-combobox' "
			w "	name='"_field_"' "
			w " style='width:"_dicWidth_";height:"_dicHeight  ;2018-03-30 布局一行加样式调整
			w ";"_attrStyle_"'"  ;2018-03-30 布局一行加样式调整
			i "Y"=requried{
				w " required"	
			}
			w " id='"_dicField_"'" 
			w " >"
			
			w "<option value='' ></option> "
			;s itm=""
			;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
			
			s seq=""  /// 2021-02-04 cy 索引替换， 顺序号起作用
			f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
			.s itm=""
			.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
			
			..s dicdata=^User.DHCAdvFormDicD(itm)
			..s subtitle=$LIST(dicdata,4)
			..s subtitle=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",subtitle)  ;2020-06-28 cy

			..w "<option "
			..w "value='"_$LIST(dicdata,16)_"' "
			..i (text=$LIST(dicdata,16)) d
			...w "selected = 'selected'"
			..w " >"
			..w subtitle
			..w "</option>"
			w "</select>"
		}else{
			w "<input type='input' data-parref='"_parrefDicField_"'"
			w " id="_dicField
			w " style='width:"_dicWidth_";height:"_dicHeight  ;2018-03-30 布局一行加样式调整 
			w ";"_attrStyle  ;2018-03-30 布局一行加样式调整
			; 2021-06-09 cy 父元素-子元素隐藏与显示
			i (dialayFlag'="Y")&&(parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
			.i ((recordId="")||(((recordId'="")&&'$d(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,+parref)))))  d
			..w "display:none;"
			w "'"
			w "	name='"_field_"' "
			i (style="select-change"){
				i recordId=""{
					//默认选中第一条
					s text="",tmpText=""
					;f  s tmpText=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,tmpText)) q:(tmpText="")||(text'="")  d
					s seq=""  /// 2021-02-04 cy 索引替换， 顺序号起作用
					f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
					.s tmpText=""
					.f  s tmpText=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,tmpText)) q:(tmpText="")||(text'="")  d
					
					..q:"Y"=$LISTGET(^User.DHCAdvFormDicD(tmpText),23)
					..s text=tmpText	
				}
				
				s:+text'=0 selectChangeLabel=$LIST(^User.DHCAdvFormDicD(text),16)
				s url="dhcapp.broker.csp?ClassName=web.DHCADVFormDic&MethodName=listDicFirstLevel&id="_id	
				w "	class='easyui-combobox' " 
				w " data-options=""valueField:'value',textField:'text',url:'"_url_"',"
				w "onSelect:function(rec){selec_change(this,rec.value,"_formid_","_id_");}"" " 
			}else{
				i $f($LIST(dicData,3),"date")>0 {
					w " data-options=""validType:'valDate'"" "
				}
				s:style="input" style="easyui-validatebox dhcc-input"
				w "	class='"_style_"' "
				i style="easyui-combobox"{
					w " data-options=""valueField:'value',textField:'text',url:'"_$ZCVT(url,"O","HTML")_"'"" " 	
				}
			}
			//w text,!
			w " value='"_text_"'" 
			i "Y"=requried{
				w " required"	
			}
			w ">"
		}
		i parref'=0 d
		.w "</label>"  ;2019-12-31 cy input元素 标题用label标签包含
		if (style="select-change"){
			w "&nbsp;&nbsp;&nbsp;&nbsp;<label id='label"_formid_"-"_id_"' style='position: absolute;width:700px'>"_selectChangeLabel_"</label>"	
		}	
			
	}
	
	
	i (style="radio")||(style="checkbox")
	{
		i ($$ALPHAUP^SSUTIL4(url)=""){
			w "<label style='margin: 0px;padding: 0px;display:inline-block;"
			; 2021-06-09 cy 父元素-子元素隐藏与显示
			i (dialayFlag'="Y")&&(parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
			.i ((recordId="")||(((recordId'="")&&'$d(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,+parref)))))  d
			..w "display:none;"  
			
			//s attrStyle="width:230;"
			//元素的额外样式
			i attrStyle="" d
			.i (+width'=0)&&(subDicSameLine'="Y") d 
			..;i (+width'=0)&&(subDicTile'="Y") d  //hxy 2018-06-06 平铺 st
			...;w "width:"_width_";"
			..w "width:"_width_";" //hxy 2018-06-06 平铺 ed
			e  d
			.w attrStyle_";"
			
			w "min-height:32px'" ;2021-07-27 cy height改为 min-height 不固定label高度，容易出现重叠现象
			w " data-parref='"_parrefDicField_"'" 
			w " id='"_fieldlable_"'>" //hxy 2017-12-07  32px->20 会引起遮盖！
			w "<input " 
			w "	type='"_style_"'  "
			if (hiddenValue'=""){
				w "	value='"_hiddenValue_"' "	
			}else{
				w "	value='"_title_"' "	
			}
			
			i (style="radio"){
				w "	data-id='"_field_"' "
				w "	name='"_formid_"."_parref_"' "
			}else{
				w "	name='"_field_"' "	
			}
			if text'=""{
				w " checked='checked' "	
			}
			w " id="_dicField
			i (hiddenSub="Y") d
			.i subDicSameLine="Y" d
			..w " onclick=checkbox_inline_change(this,'"_dicField_"',"_formid_","_id_")"
			.e  d
			..w " onclick=checkbox_change(this,"_id_","_formid_","_id_")"
			e  d
			.w " onClick='showPre(this)' "
			d ..WriteFormValid(requried)
			w "   />"
			
			w "<label "
			w "for='"_dicField_"'"
			w " style='margin-top=:-3px' "
			w " >"
			w title
			w "</label>"
			w "</label>"
			i (subDicSameLine="Y"){ 
				s itm=""
				//f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
				s seq=""
				f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
				.s itm=""
				.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
				..d ..ToElementHtml(itm, formid, recordId,0)
			}
		}else {
			//从
			d ##class(User.DHCADVFormHelp).WriteUrlRadioCheckbox(id,formid,recordId)	
		}
	}
	
	i (style="radio-input")||(style="checkbox-input")
	{
		
		w "<label style=';margin:0px;padding: 0px;display:inline-block;"
		; 2021-06-09 cy 父元素-子元素隐藏与显示
		i (dialayFlag'="Y")&&(parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
		.i ((recordId="")||(((recordId'="")&&'$d(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,+parref)))))  d
		..w "display:none;"
		
		//s attrStyle="width:230;"
		//元素的额外样式
		i attrStyle="" d
		.i (+width'=0)&&(subDicSameLine'="Y") d
		..w "width:"_width_";" 
		e  d
		.w attrStyle_";" 
		w "	min-height:32px;' "  ;2021-07-27 cy height改为 min-height 不固定label高度，容易出现重叠现象
		w " data-parref='"_parrefDicField_"'" 
		w " id='"_fieldlable_"'>"  //hxy 2017-12-07  32px->20
		
		////////////////radio checkbox //////////////////////////////////////////
		w "<input  "
		w "	type='"_$p(style,"-",1)_"' "
		w " data-type='"_style_"' "
		i (style="radio-input"){
			w "	data-id='"_field_"' "
			w "	name='"_formid_"."_parref_"' "
		}else{
			w "	name='"_field_"' "	
		}
		w " value='title' " 
		if text'=""{
			w " checked='checked' "	
		}
		w " id="_dicField
		d ..WriteFormValid(requried)
		w " onClick='showPre(this)' />"
		
		w "<label "
		w "for='"_dicField_"'"
		w " style='margin-top:3px;z-index:0'"
		w " >"
		
		w title
		
		w "</label>"
		//////////////// input //////////////////////////////////////////		
		w "<input "
		i (style="radio-input"){
			w "	data-id='"_field_"' "
		}
		w "	name='"_field_"' "
		s:value="title" value=""	
		w " value='"_value_"' type='input'  "
		w " style='z-index:1;width:"_dicWidth_";height:"_dicHeight
		
		if text=""{
			w ";display:none"
		}
		w "'" 
		w " class='lable-input' "
		w " /></label>"
	}
	
	i (style="radio-date")||(style="checkbox-date")
	{
		
		s width=$p(width,"%",1)
		w "<label style=';margin: 0px;padding: 0px;display:inline-block;width:"_width_"%;min-height:32px' id='"_fieldlable_"'>"  ;2021-07-27 cy height改为 min-height 不固定label高度，容易出现重叠现象
		////////////////radio checkbox //////////////////////////////////////////
		w "<input  "
		w "	type='"_$p(style,"-",1)_"' "
		w " data-type='"_style_"' "
		i (style="radio-input"){
			w "	data-id='"_field_"' "
			w "	name='"_formid_"."_parref_"' "
		}else{
			w "	name='"_field_"' "	
		}
		w " value='title' " 
		if text'=""{
			w " checked='checked' "	
		}
		w " id="_dicField
		d ..WriteFormValid(requried)
		w " onClick='showPreDatebox(this)' />"
		
		w "<label "
		w "for='"_dicField_"'"
		w " style='margin-top:3px;z-index:0;display: initial'"
		w " >"
		
		w title
		
		w "</label>"

		w "</label>"
				//////////////// input //////////////////////////////////////////		
		w "<input "
		i (style="radio-date"){
			w "	data-id='"_field_"' "
		}
		w "	name='"_field_"' "	
		w " value='"_value_"' type='input'  "
		w " style='z-index:1;width:"_dicWidth_";height:"_dicHeight
		
		if text=""{
			w ";display:none"
		}
		w "'"
		w " data-type-complex-select='complex-select' "
		w " data-value-complex-select='"_text_"' " 
		w " class='"_inputLable_"' "
		w " />"
	}
	
	i (style="radio-select")||(style="checkbox-select")
	{
		w "<label style='margin: 0px;padding: 0px;display:inline-block;"_attrStyle_"'><input type='"_$p(style,"-",1)_"' name='"_field_"' "
		if text'=""{
			w " checked='checked' "	
		}
		d ..WriteFormValid(requried)
		w "  onClick='showCombox(this)' />"_title
		w "</label>"
		i ($$ALPHAUP^SSUTIL4(url)=""){
			w "&nbsp;&nbsp;<select class='easyui-combobox' "
			w " data-type-complex-select='complex-select' "
			w " data-value-complex-select='"_text_"' "
			w "	name='"_field_"' "
			w " style='width:"_dicWidth_";height:"_dicHeight_";float:left'" 
			w " >"	
			w "<option value='' ></option> "
			;s itm=""
			;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
			
			s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
			f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
			.s itm=""
			.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d

			
			..s dicData=^User.DHCAdvFormDicD(itm)
			..w "<option "
			..w "value='"_$LIST(dicData,16)_"' "
			..i (text=$LIST(dicData,16)) d
			...w "selected = 'selected'"
			..w " >"
			..w $LIST(dicData,4)
			..w "</option>"
			w "</select>"
		}else{
			w "&nbsp;&nbsp;<input "
			w " data-type-complex-select='complex-select' "
			w " data-value-complex-select='"_text_"' "
			w " class='easyui-combobox' "
			w " name='"_field_"' "
			w "data-options=""valueField:'value',textField:'text',url:'"_url_"'"" value='"_value_"'  style='width:"_dicWidth_";height:"_dicHeight_";' />"
		}	
	}
	
	
	i (style="textarea"){
		
		w "<textarea  cols="_cols_" rows="_rows_" id="_dicField_" name='"_field_"' type='textarea' style='"_attrStyle_"'"
		d ..WriteFormValid(requried)
		w ">"
		w value
		w "</textarea>"
	}

	q:+$o(^User.DHCAdvFormDicI("IndexParef"," "_id,""))=0 ""

	///同级select-change 在父级row同级显示 
	q:($LIST(^User.DHCAdvFormDicD(id),15)="Y")&&(style="select-change") ""
	q:(style="easyui-combobox")&&($$ALPHAUP^SSUTIL4(url)="") ""
	q:(style="checkbox-select") ""
	q:(style="popModel") ""
	//初始化默认不显示子元素
	q:(subDicSameLine="Y")
	
	w "<div id="_formid_"-"_id_" >"
	i sameLevel'="Y" d
	.w "<ul>"
	.w "<li >"
	.w "<div style='margin-top: 5px;'>"
	
	i style="datagrid" d
	.//输出datagrid
	.d ..WriteDataGrid(id,formid,recordId)
	e  i style="table" d
	.d ..WriteTable(id,formid,recordId)
	e  i style="tab" d
	.d ..WriteTab(formid,id,recordId,style)
	e  d
	.//普通元素的子元素输出
	.s existFlag=0
	.i (style="checkbox")||((style="radio")) d
	..i hiddenSub="Y" d
	...s:+recordId=0 existFlag=1
	...s:(+recordId'=0)&&(value="") existFlag=1
	...
	.q:existFlag=1
	.d ..WriteCommonItm(formid,id,recordId,style)
	
	
	i sameLevel'="Y" d
	.w "</div>"
	.w "</li>"
	.w "</ul>"
	w "</div>"
	q ""
}

// 输出必填验证

ClassMethod WriteFormValid(requried)
{
	i "Y"=requried{
		w " class='easyui-validatebox' "
		w " required	"	
	}
}

ClassMethod GetColumnWidth(id, tmpitm)
{
	q:+id=0 "100%"
	s itm1=tmpitm,count=0,newLine=""
	;f  s itm1=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm1)) q:(itm1="")||(newLine="Y")  d
	
	s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
	.s itm1=tmpitm
	.f  s itm1=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm1)) q:(itm1="")||(newLine="Y")  d
	
	..s newLine=$LIST(^User.DHCAdvFormDicD(itm1),8)
	..q:newLine="Y"
	..s count=count+1

	q:count=0 "100%"
	q 1/count*100_"%"
}

// 输出元素字典子元素

ClassMethod WriteTab(formid, id = "", recordId = "", style = "")
{
	
	q:+id=0
	s parref=id
	
	
	w "<div class='easyui-tabs' style='width:900px'>"
	;s itm=""
	;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
	s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
	.s itm=""
	.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
	
	..w "<div title='"_##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",$ListGet(^User.DHCAdvFormDicD(itm),4))_"' style='padding:10px' >"  ;2020-06-28 cy
	..w "<div style='margin-top: 5px;'>"
	..s subitm="",width=..GetColumnWidth(parref,"")
	..;f  s subitm=$o(^User.DHCAdvFormDicI("IndexParef"," "_itm,subitm)) q:subitm=""  d
	
	..s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	..f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_itm,seq)) q:seq=""  d
	...s subitm=""
	...f  s subitm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_itm,seq,subitm)) q:subitm=""  d
	
	....d ..ToElementHtml(subitm,formid,recordId,width)
	..w "</div>"
	..w "</div>"

	w "</div>"
}

// 输出元素字典子元素

ClassMethod WriteCommonItm(formid, id = "", recordId = "", style = "")
{
	
	q:+id=0
	q:"Y"=$LISTGET(^User.DHCAdvFormDicD(id),23)
	s parref=id
	i style="select-change" d
	.//select的onchange可以带出对应二级元素对应的子元素
	.i recordId="" d
	..s parref="",tmpText=""
	..;f  s tmpText=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,tmpText)) q:(tmpText="")||(parref'="")  d
	..s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	..f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
	...s tmpText=""
	...f  s tmpText=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,tmpText)) q:(tmpText="")||(parref'="")  d
	....q:"Y"=$LISTGET(^User.DHCAdvFormDicD(tmpText),23)
	....s parref=tmpText
	..e  d
	...s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,id,""))
	...i recordItmId'=0 d
	....s parref=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)	
	
	s width=..GetColumnWidth(parref,"")
	q:parref=""
	;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_parref,itm)) q:itm=""  d
	s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_parref,seq)) q:seq=""  d
	.s itm=""
	.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_parref,seq,itm)) q:itm=""  d
	..d ..ToElementHtml(itm,formid,recordId,width)
}

/// 输出对比表格
ClassMethod WriteTable(id, formid, recordId = "")
{
	
	n (%session)
	s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",formid,id,""))
	i attr'=0 d
	.s attrStr=$LISTTOSTRING(^User.DHCADVFormAttrD(attr),"^",1)
	.s attrStyle=$p(attrStr,"^",8)	
	s itm=""
	w "<table class='dhc-table' >"
	
	w "<thead><tr>"
	;s subDicId=""
	;f  s subDicId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,subDicId)) q:subDicId=""  d

	s subseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s subseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,subseq)) q:subseq=""  d
	.s subDicId=""
	.f  s subDicId=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,subseq,subDicId)) q:subDicId=""  d
	..i $ListGet(^User.DHCAdvFormDicD(subDicId),4)="1" d
	...;f  s dicId=$o(^User.DHCAdvFormDicI("IndexParef"," "_subDicId,dicId)) q:dicId=""  d
	...s dicseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	...f  s dicseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_subDicId,dicseq)) q:dicseq=""  d
	....s dicId=""
	....f  s dicId=$o(^User.DHCAdvFormDicI("IndexSeq"," "_subDicId,dicseq,dicId)) q:dicId=""  d
	.....s dicWidth=$LIST(^User.DHCAdvFormDicD(dicId),10)
	.....w "<th "
	.....q:$LIST(^User.DHCAdvFormDicD(dicId),23)="Y"     /// 2019-11-21 cy 隐藏表格元素
	.....;.w "style='display:none;'"
	.....i +dicWidth'=0 d
	......w "width="_dicWidth
	.....w ">"
	.....w ##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",$ListGet(^User.DHCAdvFormDicD(dicId),4))  ;2020-06-28 cy
	.....w "</th>"
	w "</tr></thead>"
	w "<tbody>"
	
	//循环table下的行
	s rowDicId="",rownum=0,rowseq=""  /// 2021-02-04 cy 索引替换， 顺序号起作用
	;f  s rowDicId=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,rowDicId)) q:rowDicId=""  d
	f  s rowseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,rowseq)) q:rowseq=""  d
	.s rowDicId=""
	.f  s rowDicId=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,rowseq,rowDicId)) q:rowDicId=""  d
	..q:$ListGet(^User.DHCAdvFormDicD(rowDicId),4)="1"
	..q:$ListGet(^User.DHCAdvFormDicD(rowDicId),23)="Y"
	..//输出复制的行
	..i ("Y"=$LISTGET(^User.DHCAdvFormDicD(rowDicId),19))&&(+recordId'=0) d
	...s pid=$i(^DHCADVCOMMON("FORMDIC","TABLE",formid,id))
	...k ^TMP("User.DHCAdvForm","TableAppendTRRow",pid) 
	...s tmpDic=""
	...f  s tmpDic=$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,tmpDic)) q:tmpDic=""  d
	....q:$ListGet(^User.DHCAdvFormDicD(tmpDic),23)="Y"
	....s row="" 
	....f  s row=$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,tmpDic,row)) q:row=""  d
	.....s ^TMP("User.DHCAdvForm","TableAppendTRRow",pid,row)=""
	...
	...s row=""
	...f  s row=$o(^TMP("User.DHCAdvForm","TableAppendTRRow",pid,row)) q:row=""  d
	....w "<tr>"
	....s colseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	....f  s colseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_rowDicId,colseq)) q:colseq=""  d
	.....s colDicId=""
	.....f  s colDicId=$o(^User.DHCAdvFormDicI("IndexSeq"," "_rowDicId,colseq,colDicId)) q:colDicId=""  d
	......s dichidden=$LIST(^User.DHCAdvFormDicD(colDicId),23)
	......q:dichidden="Y"
	......w "<td>"
	......d ..WriteTableTdHtml(colDicId,formid,recordId,row)
	......w "</td>"
	
	
	
	....i "Y"=$LISTGET(^User.DHCAdvFormDicD(rowDicId),19) d  //2018-04-17 cy 增加删除按钮（table数据已保存展现删除按钮）
	.....w "<td>" //2018-04-17 cy 增加删除按钮（table数据已保存展现删除按钮）
	.....w "<a class='easyui-linkbutton' data-options=""iconCls:'icon-remove',plain:true"" onclick='javascript:removeRow(this)' >"_##class(websys.Translation).Get("dhcadv.layoutform.csp","删除")_"</a>"   //2018-04-17 cy 增加删除按钮（table数据已保存展现删除按钮）
	.....w "</td>"
	....w "</tr>"
	..//没有复制行情况
	..w "<tr>"
	..s row=rownum
	..i "Y"=$LISTGET(^User.DHCAdvFormDicD(rowDicId),19) d
	...s row=$i(^DHCADVCOMMON("FORMDIC","DATAGRID",formid,rowDicId))  
	
	..s dicseq=""
	..f  s dicseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_rowDicId,dicseq)) q:dicseq=""  d
	...s dicId=""
	...f  s dicId=$o(^User.DHCAdvFormDicI("IndexSeq"," "_rowDicId,dicseq,dicId)) q:dicId=""  d

	....s:(recordId'="")&&($d(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,dicId)))&&($LISTGET(^User.DHCAdvFormDicD(rowDicId),19)'="Y") row=$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,dicId,""))
	....s:row<0 row=0 ; 2021-07-29 cy 不复制行的radio input 元素容易获取 row为不可用数据，所以赋值0
	....q:$ListGet(^User.DHCAdvFormDicD(dicId),23)="Y"
	....w "<td>"
	....d ..WriteTableTdHtml(dicId,formid,recordId,row)  ;2018-05-24 cy 修改语句 d ..WriteTableTdHtml(dicId,formid,"",row)  recordId一直传空,导致不复制行的数据一直不显示
	....w "</td>"
	
	
	..i "Y"=$LISTGET(^User.DHCAdvFormDicD(rowDicId),19) d
	...w "<td>"
	...w "<a class='easyui-linkbutton' data-options=""iconCls:'icon-add',plain:true"" onclick='javascript:addRow(this,"_rowDicId_","_formid_")' >"_##class(websys.Translation).Get("dhcadv.layoutform.csp","增加")_"</a>"
	...w "</td>"
	..w "</tr>"
	w "</tbody>"	
	w "</table>"
}

/// 输出compareDataGrid的元素
ClassMethod WriteTableTdHtml(id, formid, recordId = "", row = "", flag = "")
{
	
	q:'$d(^User.DHCAdvFormDicD(id))
	s dicData=^User.DHCAdvFormDicD(id)
	s style=$LIST(dicData,3)
	s dicField=$LIST(dicData,2)
	
	s field=formid_"."_id
	s:+row'=0 field=field_"."_row
	s:+row'=0 dicField=dicField_"."_row
	s url=$LIST(dicData,5)
	s title=$LIST(dicData,4)
	s title=##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",title)  ;2020-06-28 cy
	s value=$LIST(dicData,7)
	s dicWidth=$LIST(dicData,10)
	s dicHeight=$LIST(dicData,11)
	s cols=$LIST(dicData,12)
	s rows=$LIST(dicData,13)
	s dicWidth=$case(dicWidth,"":130,:dicWidth)
	s dicHeight=$case(dicHeight,"":30,:dicHeight)
	s lable="lable-input"
	s inputLable="easyui-datebox  radio-date"
	s newLine=$LIST(dicData,8)
	s parref=$LISTGET(dicData,6)
	s parrefDicField=""
	s:parref'=0 parrefDicField=$LISTGET(^User.DHCAdvFormDicD(parref),2)
	s hiddenSub=$LIST(dicData,17)
	i "Y"=newLine {
		w "<div style='height:1px'></div> "
	}
	
	s text=""
	//查询已经填写过的记录
	i recordId'="" d
	.s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,id,""))
	.i recordItmId'=0 d
	..s text=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)
	..S:(text["-")&&($L(text)="10")&&($L(text,"-")="3") text=##class(web.DHCADVCOMMONPART).GetDateToHtml(text)  //2018 cy
	.//tabel append row情况
	.i +row'="0" d
	..s text=""
	..s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,+parref,row,id,""))
	..i +recordItmId'=0 d
	...s value=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)  ;2018-01-22 cy 获取radio-input 的input值
	...s text=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)  
	...S:(text["-")&&($L(text)="10")&&($L(text,"-")="3") text=##class(web.DHCADVCOMMONPART).GetDateToHtml(text)  //2018 cy
	s requried="",attrStyle=""
	s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",formid,id,""))
	i attr'=0 d
	.s:$LIST(^User.DHCADVFormAttrD(attr),4)="on" requried="Y"
	.s attrStyle=$LISTGet(^User.DHCADVFormAttrD(attr),8)

	i (style="label"){
		w "<label  " 

		//样式开始
		w " style='display:inline-block;"_attrStyle_"" // 2017-12-11 hxy cs
		i (parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
		.i recordId="" d
		..w ";display:none;"
		.e  d
		..i '$D(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,+parref,row)) d
		...w ";display:none;"

		w "'"
		//样式结束
		w " data-parref='"_parrefDicField_"."_row_"' "
		w " >"
		w title_"&nbsp;&nbsp;&nbsp;&nbsp;"
		w "</label>"
	}		
	i ((style="input")||(style="easyui-combobox")||(style="easyui-datebox")||(style="easyui-datetimebox")) 
	{
		/// 2021-07-01 cy 表格数据下拉框满足维护下拉数据  隐藏
		/*i flag="Y" d
		.w title
		w "<input type='input' "
		w " id="_dicField
		w " style='width:"_dicWidth_";height:"_dicHeight_"'" 
		w "	name='"_field_"' "
		i "Y"=requried d
		.s:style="input" style="easyui-validatebox"
		.w "	class='"_style_"' "
		..w " required	"	
		e  d
		.w "	class='"_style_"' "	 
		w " data-options=""valueField:'value',textField:'text',url:'"_url_"'"" " 		
		w " value='"_text_"' />"
		*/
		/// 2021-07-01 cy 表格数据下拉框满足维护下拉数据 st
		i ($$ALPHAUP^SSUTIL4(url)="")&&(style="easyui-combobox"){
			w "<select class='easyui-combobox' "
			w "	name='"_field_"' "
			w " style='width:"_dicWidth_";height:"_dicHeight  ;2018-03-30 布局一行加样式调整
			w ";"_attrStyle_"'"  ;2018-03-30 布局一行加样式调整
			i "Y"=requried{
				w " required"	
			}
			w " id='"_dicField_"'" 
			w " >"
			
			w "<option value='' ></option> "
			
			s seq=""  /// 2021-02-04 cy 索引替换， 顺序号起作用
			f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
			.s itm=""
			.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
			
			..s dicdata=^User.DHCAdvFormDicD(itm)
			..w "<option "
			..w "value='"_$LIST(dicdata,16)_"' "
			..i (text=$LIST(dicdata,16)) d
			...w "selected = 'selected'"
			..w " >"
			..w $LIST(dicdata,4)
			..w "</option>"
			w "</select>"
		}else{
			i flag="Y" d
			.w title
			w "<input type='input' data-parref='"_parrefDicField_"'"
			w " id="_dicField
			w " style='width:"_dicWidth_";height:"_dicHeight  ;2018-03-30 布局一行加样式调整 
			w ";"_attrStyle  ;2018-03-30 布局一行加样式调整
			; 2021-06-09 cy 父元素-隐藏子元素就不显示
			i (parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
			.i ((recordId="")||(((recordId'="")&&'$d(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,+parref)))))  d
			..w "display:none;"
			w "'"
			w "	name='"_field_"' "

			i $f($LIST(dicData,3),"date")>0 {
				w " data-options=""validType:'valDate'"" "
			}
			s:style="input" style="easyui-validatebox dhcc-input"
			w "	class='"_style_"' "
			i style="easyui-combobox"{
				w " data-options=""valueField:'value',textField:'text',url:'"_$ZCVT(url,"O","HTML")_"'"" " 	
			}
			
			//w text,!
			w " value='"_text_"'" 
			i "Y"=requried{
				w " required"	
			}
			w ">"
		}
		/// 2021-07-01 cy 表格数据下拉框满足维护下拉数据 ed
			
	}
	
	
	i (style="popSelect")
	{
		   w "<input name='"_dicField_"' /><a class='easyui-linkbutton' data-options=""iconCls:'icon-add',plain:true"" onclick='javascript:popSelect(this,"_id_","_formid_")' data-dic-field='"_dicField_"'></a>" 
	}
	
	i (style="radio")||(style="checkbox")
	{
			w "<label style='margin: 0px;padding: 0px;display:inline-block;min-height:32px;"  ;2021-07-27 cy height改为 min-height 不固定label高度，容易出现重叠现象
			
			//父元素是隐藏子元素就不显示
			i (parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
			.i recordId="" d
			..w "display:none;"
			.e  d
			..i +row=0 d
			...i '$d(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formid,+parref)) d
			....w "display:none;"
			..e  d
			...i '$D(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,+parref,row)) d
			....w "display:none;"
			
			w attrStyle_"'"
			w " data-parref='"_parrefDicField_"."_row_"' " 
			;w " id="_dicField_"'>"
			w " id='label"_dicField_"'>"    ;丛悦修改 tabel里面包含checkbox radio元素的label元素的 id显示为 label+dicField
			w "<input " 
			w "	type='"_style_"'  "
			w "	value='"_title_"' "	
			i (style="radio"){
				w "	data-id='"_field_"' "
				w "	name='"_formid_"."_parref_"."_row_"' "
			}else{
				w "	name='"_field_"' "	
			}
			if text'=""{
				w " checked='checked' "	
			}
			;w " id='label"_dicField_"'"
			w " id="_dicField_""    ;丛悦修改 tabel里面的checkbox radio元素 id显示为 dicField
			i (hiddenSub="Y") d
			.w " onclick=checkbox_inline_change(this,'"_dicField_"',"_formid_","_id_")"
			w "   />"
			
			w "<label "
			;w "for='label"_dicField_"'"  
			w "for='"_dicField_"'"   ; 保持与input 一致的id
			w " style='margin-top=:-3px' "
			w " >"
			w title
			w "</label>"
			w "</label>"
	}
	i (style="radio-input")||(style="checkbox-input")
	{
		
		w "<label style=';margin-left:16px;padding: 0px;display:inline-block;min-height:32px;"_attrStyle_";"  ;2021-07-27 cy height改为 min-height 不固定label高度，容易出现重叠现象
		i (parref'=0)&&($LISTGET(^User.DHCAdvFormDicD(parref),17)="Y") d
		.i recordId="" d
		..w "display:none;"
		.e  d
		..i text="" d
		...w "display:none;"
		w "'"
		w " data-parref='"_parrefDicField_"."_row_"' " 
		w " id='label"_dicField_"'>"
		

		w "<input  "
		w "	type='"_$p(style,"-",1)_"' "
		w " data-type='"_style_"' "
		i (style="radio-input"){
			w "	data-id='"_field_"' "
			w "	name='"_formid_"."_parref_"."_row_"' "  ;cy 修改 给table里面的radio-input元素 name添加row
		}else{
			w "	name='"_field_"' "	
		}
		w " value='title' " 
		if text'=""{
			w " checked='checked' "	
		}
		w " id="_dicField
		w " onClick='showPre(this)' />"
		
		w "<label "
		w "for='"_dicField_"'"
		w " style='margin-top:3px;z-index:0'"
		w " >"
		
		w title
		
		w "</label>"
		//////////////// input //////////////////////////////////////////		
		w "<input "
		i (style="radio-input"){
			w "	data-id='"_field_"' "
		}
		w "	name='"_field_"' "
		s:value="title" value=""	
		w " value='"_value_"' type='input'  "
		w " style='z-index:1;width:"_dicWidth_";height:"_dicHeight
		
		if text=""{
			w ";display:none"
		}
		w "'" 
		w " class='lable-input' "
		w " /></label>"
	}
	
	i (style="textarea"){	
		w "<textarea  cols="_cols_" rows="_rows_" id="_dicField_" name='"_field_"' type='textarea' "
		w " style='margin:0'>"
		w text
		w "</textarea>"
	}
	q:(style="easyui-combobox")&&($$ALPHAUP^SSUTIL4(url)="") ""  /// 2021-07-01 cy 表格数据下拉框满足维护下拉数据 st
	q:(style="popSelect")
	s seq=""
	f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
	.s subDicId=""
	.f  s subDicId=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,subDicId)) q:subDicId=""  d
	..d ..WriteTableTdHtml(subDicId,formid,recordId,row,"Y")
}

/// d ##class(User.Form).WriteDataGrid("","")
ClassMethod WriteDataGrid(id, formid, recordId = "")
{
	
	n (%session)
	s attrStyle=""
	s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",formid,id,""))
	i attr'=0 d
	.s attrStr=$LISTTOSTRING(^User.DHCADVFormAttrD(attr),"^",1)
	.s attrStyle=$p(attrStr,"^",8)	
	
	;s itm=""
	w "<table class='dhc-table' style='"_attrStyle_"' >"
	
	w "<thead><tr>"
	;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
	
	s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
	.s itm=""
	.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
	
	..s requried=""
	..s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic"," "_formid,itm,""))
	..i attr'=0 d
	...s:$LIST(^User.DHCADVFormAttrD(attr),4)="on" requried="Y"
	..w "<th "
	..i requried="Y" d
	...w "style='color:red'"
	..i $LIST(^User.DHCAdvFormDicD(itm),23)="Y" d  /// 2019-11-21 cy 隐藏表格元素
	...w "style='display:none;'"
	..w ">"
	..w ##Class(web.DHCADVCOMMON).GetTransDesc("User.DHCAdvFormDic","title","",$LIST(^User.DHCAdvFormDicD(itm),4))  ;2020-06-28 cy
	..i requried="Y" d
	...w "<em>*</em>"
	..w "</th>"
	w "<th><a class='easyui-linkbutton' data-options=""iconCls:'icon-add',plain:true"" onclick='javascript:addRow(this,"_id_","_formid_")' >"_##class(websys.Translation).Get("dhcadv.layoutform.csp","增加")_"</a></th>"
	w "</tr></thead>"
	w "<tbody>"
	i recordId="" d
	.d ##class(User.DHCADVFormHelp).getSubDatagrid(formid,id)
	e  d
	.s row=""
	.f  s row=$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formid,id,row)) q:row=""  d
	..d ##class(User.DHCADVFormHelp).getSubDatagrid(formid,id,row,recordId)
	w "</tbody>"	
	w "</table>"
}

/// 查找元素中的panel和fieldset元素
Method checkPanel(formName, formId, version, recordId = "")
{
	
	s ret=0,subform="",count=0,width="100%",key="",style=""
	f  s subform=$o(^User.DHCAdvFormI("IndexNameVersionParef",formName," "_version," "_formId,subform)) q:(subform="")||(ret'=0)  d
	.s dic=$LIST(^User.DHCAdvFormD(subform),4)
	.q:+dic=0
	.q:'$d(^User.DHCAdvFormDicD(dic))
	.s dicdata=^User.DHCAdvFormDicD(dic)
	.s:$List(dicdata,3)="panel" ret=$List(dicdata,4),key=$List(dicdata,2),style=$List(dicdata,3)
	.s:$List(dicdata,3)="fieldset" ret=$List(dicdata,4),key=$List(dicdata,2),style=$List(dicdata,3)
	.i recordId'="" d 
	..s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,subform,dic,""))
	..s:recordItmId'=0 count=count+1
	s:count>0 width=1/count*100_"%"
	q ret_"^"_width_"^"_key_"^"_style
}

/// /////////////////////////////////////////////print/////////////////////////////////////
/// 打印输出grid
Method PrintGrid(recordId, pid, panelKey = "", version = "")
{
	

	s type=..rowType
	s rowStyle=..rowStyle
	i +version=0 d
	.s version=$LIST(^User.DHCAdvFormRecordD(recordId),3)
	i (type="column")||(type="row") {
		
		s checkPanel=..checkPanel(..formName.%Id(),..%Id(),version,recordId)
		s panelTitle=$p(checkPanel,"^",1)
		s:panelKey="" panelKey=$p(checkPanel,"^",3)
		i panelTitle'=0 d
		.w "<ul style='border:1px solid #000'>"
		.w "<li><h3>"_panelTitle_"</h3></li>"
		.w "<li>"
		s subform=""
		f  s subform=$o(^User.DHCAdvFormI("IndexNameVersionParef",..formName.%Id()," "_version," "_..%Id(),subform)) q:subform=""  d
		.s obj=##class(User.DHCAdvForm).%OpenId(subform)
		.d obj.PrintGrid(recordId,pid,panelKey,version)
		i panelTitle'=0 d
		.w "</li>"
		.w "</ul>"
	}
	i type="element"{
			s style=rowStyle
			i style'="panel"{	
					i ($ISOBJECT(..formDic)){
						d ..PrintFormItm(..formDic.%Id(),..%Id(),recordId,pid,panelKey)
					}
			}	 
	}
}

/// 打印表单元素
ClassMethod PrintFormItm(formDic = "", formItm = "", recordId = "", pid = "", panelKey = "")
{
	
	s formId=$List(^User.DHCAdvFormD(formItm),2)
	s style=$List(^User.DHCAdvFormDicD(formDic),3)
	s url=$List(^User.DHCAdvFormDicD(formDic),5)
	s title=$List(^User.DHCAdvFormDicD(formDic),4)
	s formCode=$List(^User.DHCAdvFormDicD(formDic),7)
	s parent=+$List(^User.DHCAdvFormDicD(formDic),6)
	s parentStyle=""
	s:parent'=0 parentStyle=$List(^User.DHCAdvFormDicD(parent),3)
	s subValue=""
	s subStyle=""
	s value=""
	s htmlDian=".&nbsp"
	i (style="form"){
		q:formCode=""
		d ##class(web.DHCADVFormPrint).PrintForm(recordId,formCode,pid,panelKey)
	}
	q:style="form"
	//查询已经填写过的记录
	s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formItm,formDic,""))
	i recordItmId'=0 d
	.s value=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)
	
	;s dicitm=""
	;f  s dicitm=$o(^User.DHCAdvFormDicI("IndexParef"," "_formDic,dicitm)) q:(dicitm="")||(subValue'="")  d
 	
	s dicseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s dicseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq)) q:dicseq=""  d
	.s dicitm=""
	.f  s dicitm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq,dicitm)) q:(dicitm="")||(subValue'="")  d
 	
 	
 	..s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formItm,dicitm,""))
	..s:recordItmId'=0 subValue=1
	..s subStyle=$List(^User.DHCAdvFormDicD(dicitm),3)

	s i=0
	i (value'="")&&(..CheckPrint(formItm,formDic)=1) {
		
		i ..CheckPrintSeq(formItm,formDic)=1 {
			i panelKey'=""{
				s i=$i(^TMP("web.FormRecordPrint","PrintForm","panelCount",pid,panelKey))
			}else{
				s i=$i(^TMP("web.FormRecordPrint","PrintForm","panelCount",pid))
			}	
		}
		
		i ((style="radio-input")||(style="checkbox-input")||(style="easyui-datetimebox")||(style="easyui-datebox")||(style="easyui-validatebox")||(style="input")) 
		{	
			i (style="easyui-datetimebox"){
				s value=$REPLACE(value," ",":")
				s value=$e(value,1,10)_" "_$e(value,12,19)
					
			}
			w "<label style='margin: 0px;padding: 0px;display:inline-block;width:33%;'>"
			i i'=0{
				w i_htmlDian	
			} 
			i ((style'="checkbox")&&(style'="radio")) {
				w title_":"
			}
			if ($$ALPHAUP^SSUTIL4(url)=""){
			 	w "<strong>"_value_"</strong>"
			}else{
				w "<strong>"_##class(web.FormDic).getUrlValue(url,value)_"</strong>"
			}
			i ((style="checkbox")&&(style="radio")) {
				w ","
			}
			w "</label>"
		}
		if (style="textarea"){
			
			i $l(title_value)>24{
				w "<div></div>"
			}	
			w "<label style='margin: 0px;padding: 0px;display:inline-block;width:100%;'>"
			i i'=0{
				w i_htmlDian	
			} 
			i (parent=0) {
				w title_":"
			}
			w "<strong>"_value_"</strong>"
			w "</label>"
		}
		if (style="checkbox"){
			i (subValue="") {
				w "<label style='margin-left:15px;padding: 0px;display:inline-block'>"
				i i'=0{
					w i_htmlDian	
				}
				 
				w "<strong>"_title_"</strong>"
				
				d ..PrintSubDic(formDic,formItm,recordId,pid,panelKey,style,value)
				w "</label>"	
			}else{
				w "<div style='"
				i parent'=0{
					
						w "margin-left:25px"	
					
				}
				w "'>"
				i i'=0{
					w i_htmlDian	
				} 
				w "<strong style='margin-right:25px'>"_title_"</strong>"
				
				d ..PrintSubDic(formDic,formItm,recordId,pid,panelKey,style,value)
				w "</div>"
			}
			

		}
		if (style="radio"){
			w "<label style='margin-left:15px;padding: 0px'>"
			i i'=0{
				w i_htmlDian	
			} 
			w "<strong>"_title_"</strong>"
			w "</label>"	
		}
		i (style="easyui-combobox") 
		{   
			 //w $l(title_value),!
			 i $l(title_value)>24{
				 w "<label style='margin: 0px;padding: 0px;display:inline-block;width:100%;'>"
			 }else{
				 w "<label style='margin: 0px;padding: 0px;display:inline-block;width:33%;'>"
			 }
			 
			 i i'=0{
				w i_htmlDian	
			 } 
			 w title_":"
			 w "<strong>"_value_"</strong>"
			 w "</label>"
		}	
		i (style="select-change"){
			
			i (value'=0){
				w "<div>"
				i i'=0{
					w i_htmlDian	
				} 
				w title_":"
				w "<strong>"_$List(^User.DHCAdvFormDicD(value),4)_"</strong>"
				w "</div>"
			}
		}
		
	}
	
	
	i (style="label"){
		
		//label-label-checkbox 特殊处理
		i (subStyle="label") {
			;s dicitm=""
			;f  s dicitm=$o(^User.DHCAdvFormDicI("IndexParef"," "_formDic,dicitm)) q:(dicitm="")||(subValue'="")  d
			
			s dicseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
			f  s dicseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq)) q:dicseq=""  d
			.s dicitm=""
			.f  s dicitm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq,dicitm)) q:(dicitm="")||(subValue'="")  d
			
			
			..;s dicitmsub=""
			..;f  s dicitmsub=$o(^User.DHCAdvFormDicI("IndexParef"," "_dicitm,dicitmsub)) q:(dicitmsub="")||(subValue'="")  d
 			
			..s dicsubseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
			..f  s dicsubseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_dicitm,dicsubseq)) q:dicsubseq=""  d
			...s dicitmsub=""
			...f  s dicitmsub=$o(^User.DHCAdvFormDicI("IndexSeq"," "_dicitm,dicsubseq,dicitmsub)) q:(dicitmsub="")||(subValue'="")  d

 			....s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formItm,dicitmsub,""))
			....s:recordItmId'=0 subValue=1
		}
		
		
		i (subValue'="")&&(parentStyle'="select-change"){
			i ..CheckPrintSeq(formItm,formDic)=1 {
				i panelKey'=""{
					s i=$i(^TMP("web.FormRecordPrint","PrintForm","panelCount",pid,panelKey))
				}else{
					s i=$i(^TMP("web.FormRecordPrint","PrintForm","panelCount",pid))
				}	
			}
			w "<div style='"
			i parent'=0{
				w ";margin-left:25px"
			}
			w "'>"
			i i'=0{
				w i_htmlDian
			}
			w title
			d ..PrintSubDicInline(formDic,formItm,recordId,pid,panelKey,style,value)
			w "</div>"
		}
	}
	i (style="datagrid"){
		

		s valueFlag=+$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formItm,formDic,""))
		
		i valueFlag'=0{
			w title
			w "<ul>"
			w "<li >"
			w "<table class='dhc-table'>"
			w "<thead><tr>"
			;s itm=""
			;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_formDic,itm)) q:itm=""  d
			s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
			f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,seq)) q:seq=""  d
			.s itm=""
			.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,seq,itm)) q:itm=""  d
			
			..w "<th>"	
			..w $List(^User.DHCAdvFormDicD(itm),4)
			..w "</th>"
			w "</tr></thead>"
			w "<tbody>"
			s row=""
			f  s row=$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordId,formItm,formDic,row)) q:row=""  d
			.d ..getPrintSubDatagrid(formItm,formDic,row,recordId)
			w "</tbody>"	
			w "</table>"
			w "</li>"
			w "</ul>"
		}
	}	
	q:(+$o(^User.DHCAdvFormDicI("IndexParef"," "_formDic,""))=0)
	q:style="easyui-combobox"
	q:style="datagrid"
	q:..CheckItmStyle(subStyle)

	d ..PrintSubDic(formDic,formItm,recordId,pid,panelKey,style,value)
}

ClassMethod getPrintSubDatagrid(formId, id, row = "", recordid = "")
{

	
	s:row="" row=$i(^DHCSTCOMMON("FORMDIC","DATAGRID",formId,id))  
	w "<tr>"
	;s itm=""
	;f  s itm=$o(^User.DHCAdvFormDicI("IndexParef"," "_id,itm)) q:itm=""  d
	s seq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s seq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq)) q:seq=""  d
	.s itm=""
	.f  s itm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_id,seq,itm)) q:itm=""  d
	
	..s style=$List(^User.DHCAdvFormDicD(itm),3)
	..s dicField=$List(^User.DHCAdvFormDicD(itm),2)
	..s field=formId_"."_itm_"."_row
	..s url=$List(^User.DHCAdvFormDicD(itm),5)
	..s title=$List(^User.DHCAdvFormDicD(itm),4)
	..s value=$List(^User.DHCAdvFormDicD(itm),7)
	..s dicWidth=$List(^User.DHCAdvFormDicD(itm),10)
	..s dicHeight=$List(^User.DHCAdvFormDicD(itm),11)
	..s dicWidth=$case(dicWidth,"":171,:dicWidth)
	..s dicHeight=$case(dicHeight,"":20,:dicHeight)
	..i recordid'="" d
	...s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexRowKey",recordid,formId,$List(^User.DHCAdvFormDicD(itm),6),row,itm,""))
	...i recordItmId'=0 d
	....s value=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)
	.w "<td >"	
	.w value
	.w "</td>"
	w "</tr>"
    q ""
}

/// 判断元素类型
ClassMethod CheckItmStyle(style = "")
{
	
	q:(style="checkbox") 1 
	q:(style="radio") 1
	q:(style="textarea") 1
	q:(style="checkbox-input") 1
	q:(style="checkbox-date") 1
	q 0
}

/// 输出表单元素
ClassMethod PrintSubDic(formDic = "", formItm = "", recordId = "", pid = "", panelKey = "", style = "", value = "")
{
		
	;s dicitm=""
	;f  s dicitm=$o(^User.DHCAdvFormDicI("IndexParef"," "_formDic,dicitm)) q:dicitm=""  d
	s dicseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s dicseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq)) q:dicseq=""  d
	.s dicitm=""
	.f  s dicitm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq,dicitm)) q:dicitm=""  d
	
	..q:(style="select-change")&&(value'=dicitm)
	..i style="select-change" d
	...d ..PrintSubDic(dicitm,formItm,recordId,pid,panelKey)
	..e  d
	...d ..PrintFormItm(dicitm,formItm,recordId,pid,panelKey)
	.//
}

/// 输出表单元素，不换行
ClassMethod PrintSubDicInline(formDic = "", formItm = "", recordId = "", pid = "", panelKey = "", style = "", value = "")
{
	
	s formId=$List(^User.DHCAdvFormD(formItm),2)
	;s dicitm=""
	;f  s dicitm=$o(^User.DHCAdvFormDicI("IndexParef"," "_formDic,dicitm)) q:dicitm=""  d
	
	s dicseq="" /// 2021-02-04 cy 索引替换， 顺序号起作用
	f  s dicseq=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq)) q:dicseq=""  d
	.s dicitm=""
	.f  s dicitm=$o(^User.DHCAdvFormDicI("IndexSeq"," "_formDic,dicseq,dicitm)) q:dicitm=""  d
	
	..
	..s style=$List(^User.DHCAdvFormDicD(dicitm),3)
	..s url=$List(^User.DHCAdvFormDicD(dicitm),5)
	..s title=$List(^User.DHCAdvFormDicD(dicitm),4)
	..s formCode=$List(^User.DHCAdvFormDicD(dicitm),7)
	..s parent=+$List(^User.DHCAdvFormDicD(dicitm),6)
	..s parentStyle=""
	..s:parent'=0 parentStyle=$List(^User.DHCAdvFormDicD(dicitm),3)
	..s subValue=""
	..s subStyle=""
	..s value=""
	..s htmlDian=".&nbsp"
	..i style="form" d 
	...q:formCode=""
	...d ##class(web.FormRecordPrint).PrintForm("",recordId,formCode,pid,panelKey)
	
	..q:style="form"
	..//查询已经填写过的记录
	
	..s recordItmId=+$o(^User.DHCAdvFormRecordItmI("IndexFormDic",recordId,formItm,dicitm,""))
	..i recordItmId'=0 d
	...s value=$LIST(^User.DHCAdvFormRecordItmD(recordItmId),4)
	..q:(style="select-change")&&(value'=dicitm)
	..
	..i (value'="")&&(..CheckPrint(formItm,dicitm)=1) d
	...
	...i style="easyui-datetimebox" d
	....s value=$REPLACE(value," ",":")
	....s value=$e(value,1,10)_" "_$e(value,12,19)
	...i style="radio-input" d
	....w htmlDian
	...e  i (style="checkbox-input")||(style="checkbox-date")  d
	....w htmlDian_title_":"_value
	...e  i (style="radio") d
	....w htmlDian_title
	...e  d
	....w htmlDian_value
	..d ..PrintSubDicInline(dicitm,formItm,recordId)
}

/// 检查是否打印元素序号
ClassMethod CheckPrintSeq(formItm = "", formDic = "")
{
	s noPrintSeq=""	//是Y的话，不打印该元素序号
	s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",formItm,formDic,""))
	i attr'=0 d
	.s:$LIST(^User.DHCADVFormAttrD(attr),5)="on" noPrintSeq="Y"
	s parent=+$LIST(^User.DHCAdvFormDicD(formDic),6)
	q:(parent=0)&&(noPrintSeq="") 1
	q 0
}

/// 检查是否打印元素
/// return
/// 1:打印
/// 0:不打印
ClassMethod CheckPrint(formItm = "", formDic = "")
{
	s print=""	//是Y的话，不打印该元素
	s attr=+$o(^User.DHCADVFormAttrI("IndexItmDic",formItm,formDic,""))
	//w formDic_"^"_formItm
	i attr'=0 d
	.s:$LIST(^User.DHCADVFormAttrD(attr),6)="on" print="Y"
	q:print="" 1
	q 0
}

}
