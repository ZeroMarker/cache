$(function() {
	var sdflag=GetURLParams("sdflag"); 	//区分是否是由结构化诊断进入此页面
	var id=GetURLParams("id");
	var editflag=GetURLParams("editflag");
	var PatientUserInfo=GetURLParams("PatientUserInfo");
	var AssDesc="" 						//评估量表名称
	
	//统一调用方法
	function ServerCallMethod(ClassName,MethodName,Input)
	{
		if (sdflag.indexOf("cdss")!=-1)		//CDSS跨域调用方法
		{
			var flag = false;
			var returnInfo = "";
			var DataInfo=ClassName+"[A]"+MethodName+"[A]"+Input;
			var str = DataInfo.replace(/\"/g, '""');
			returnInfo = tkMakeServerCall("web.CDSS.Public.MethodForWebservice", "CallMethod", str);
			return returnInfo;
		}
		else								//本地调用
		{
			var str="tkMakeServerCall('"+ClassName+"','"+MethodName+"'";
			for (var i=0;i<Input.split("[A]").length;i++)
			{
				str+=",'"+Input.split("[A]")[i]+"'";
			}
			str+=")";
			return eval(str);
		}
	}
     //获得总分
    getTheCheckBoxValue = function(){
        var checkBoxValue = 0;
        var checkbox = $("#layoutcenter input:checked");
        var selectbox = $(".combo-value");
        selectbox.each(function() {
			if ($(this).val()!=undefined&&isNaN($(this).val())) {
				checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 100;
			}
		})
        checkbox.each(function() {
            checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 100; //减0 转换成number类型
        })
        $("#allscore").text(checkBoxValue / 100);
		var rankHtml=ServerCallMethod("web.CDSS.Access.Assessment","GetDescByIdScore",id+"[A]"+checkBoxValue / 100);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);
        PatientMortality(checkBoxValue);
    }
    //获得平均分
    getAverageValue = function() {
        var checkBoxValue = 0;
        var checkbox = $("#layoutcenter input:checked");
        var selectbox = $(".combo-value");
        selectbox.each(function() {
            if (!isNaN((this).val())) {
                checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 100; //乘以10后面再除以10  解决js计算小数时丢失精度
            }
        })
        checkbox.each(function() {
            checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 100; //减0 转换成number类型
        })
        //获得它一共有几个评估项
        var RatingNum = document.getElementById( "layoutcenter" ).getElementsByTagName( "h3" ).length
        $("#allscore").text(((checkBoxValue / 100)/RatingNum).toFixed(2));
		var rankHtml=ServerCallMethod("web.CDSS.Access.Assessment","GetDescByIdScore",id+"[A]"+checkBoxValue / 100);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);
        PatientMortality(checkBoxValue);
    }
    //获得最大值
    getMaxValue = function() {
        var checkBoxValue = 0;
        var checkbox = $("#layoutcenter input:checked");
        var selectbox = $(".combo-value");
        var maxValue = 0
        selectbox.each(function() {
            if (!isNaN($(this).val())) {
	            if (($(this).val().split("_")[1] - 0)>(maxValue - 0))
	            {
		            maxValue = ($(this).val().split("_")[1] - 0)
		        }
                //checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 10; //乘以10后面再除以10  解决js计算小数时丢失精度
            }
        })
        checkbox.each(function() {
	        if (($(this).val().split("_")[1] - 0)>(maxValue - 0))
            {
	            maxValue = ($(this).val().split("_")[1] - 0)
	        }
            //checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 10; //减0 转换成number类型
        })
        //$("#allscore").text(checkBoxValue / 10);
        $("#allscore").text(maxValue)
        //获得它一共有几个评估项
		var rankHtml=ServerCallMethod("web.CDSS.Access.Assessment","GetDescByIdScore",id+"[A]"+maxValue);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);
        PatientMortality(checkBoxValue);
    }
	//互斥方法
	CheckOption=function(e)
	{
		if (e.target==undefined)
		{
			var pnode_name=e.context.parentNode.parentNode.parentNode.parentNode.className;	//题目class
		}
		else
		{
			var pnode_name=e.target.parentNode.parentNode.parentNode.parentNode.parentNode.className;	//题目class
			//选项互斥---只有复选框做选项互斥
			var id=e.currentTarget.id;
			var childsub=id.split("-")[1];
			var excloption=id.split("-")[2];
			if ("other".match(excloption)!=null&&"other".match(excloption)!="")		//取消除当前节点外的全部节点的选中状态
			{
				var contentname=$('#'+id).parent().parent().parent().parent().parent()[0].className
				var contentclass=contentname.split("-")[0];
				var checkbox=$("div[class^='"+contentclass+"'] :checked")
				checkbox.each(function(){
					$(this).checkbox("uncheck");
				})
				//return;
			}
			else
			{
				if (excloption!=undefined)
				{
					for (var i=0;i<excloption.split(",").length;i++)
					{
						var excloptionid=excloption.split(",")[i].split("T")[1];
						if($("input[id^='"+excloptionid+"-"+childsub+"']").is(":checked"))
						{
							$("input[id^='"+excloptionid+"-"+childsub+"']").checkbox("uncheck");
							//$("input[id^='"+excloption+"-"+childsub+"']").prop("checked",false);
						}
					}
				}
			}
		}
		//题目互斥
		var pnode_id=pnode_name.split("-")[1];
		if (pnode_id!="")
		{
			if ("other".match(pnode_id)!=null&&"other".match(pnode_id)!="")		//取消除当前题目外的全部题目下选项的选中状态
			{
				var checkbox=$("div[class!='"+pnode_name+"'] :checked")
				var textbox=$("div[class^='contentsequl'] input")
				checkbox.each(function(){	
					if ($(this).context.parentNode.parentNode.parentNode.parentNode.parentNode.className==pnode_name)
					{
						return true;
					}
					$(this).checkbox("uncheck");
					$(this).radio("uncheck");
				})
				if ((textbox.attr('class')=="textbox"||textbox.attr('class')=="textarea")&&textbox.val()!="")
				{
					textbox.val('');
				}
				return;
			}
			for (var i=0;i<pnode_id.split(",").length;i++)
			{
				var p_option_id=pnode_id.split(",")[i];
				var checkbox=$("div[class^='contentsequl"+p_option_id+"'] :checked")
				var textbox=$("div[class^='contentsequl"+p_option_id+"'] input")
				checkbox.each(function(){
					$(this).checkbox("uncheck");
					$(this).radio("uncheck");
				})
				if ((textbox.attr('class')=="textbox"||textbox.attr('class')=="textarea")&&textbox.val()!="")
				{
					textbox.val('');
				}
			}
		}
	}
	
	//公式/特殊计算方法
	SpecialCalculate=function(type){
		var ResObj=new Object();
		var Alllength = document.getElementById( "layoutcenter" ).getElementsByTagName( "h3" ).length
		for (var i=1;i<Alllength+1;i++)
		{
			var checkBoxValue = "";
			var checkbox=$("#contentsequlQ"+i+" :checked")
			var textbox=$("#contentsequlQ"+i+" input")
			var selectbox = $("#contentsequlQ"+i+" .shdh");
			if (selectbox.length>0)
			{
				//checkBoxValue=0;
				selectbox.each(function(){
					//if ($(this)[0].checked)
					//{
						//$('#test option:selected').val();
						//console.log($(this).combobox('getValue'))
						if(isNaN(($(this).combobox('getValue').split("_")[1])))
						{
							checkBoxValue=($(this).combobox('getValue').split("_")[1]);
						}
						else
						{
							checkBoxValue=eval(checkBoxValue+"+"+($(this).combobox('getValue').split("_")[1]));
						}
						Object.defineProperty(ResObj, "Q"+i, {
							value:checkBoxValue,
							writable : true,
							enumerable : true
							//configurable : true
						})
					//}
				})
			}
			if (checkbox.length>0)
			{
				//checkBoxValue=0;
				checkbox.each(function(){
					if(isNaN(($(this).val().split("_")[1])))
					{
						checkBoxValue=($(this).val().split("_")[1]);
					}
					else
					{
						checkBoxValue=eval(checkBoxValue+"+"+($(this).val().split("_")[1]));
					}
					var name="Q"+i;
					if (name in ResObj)
					{
						Object.defineProperty(ResObj, name, {
							writable : false
						})
					}
					else
					{
						Object.defineProperty(ResObj, name, {
							value:checkBoxValue,
							writable : true,
							enumerable : true,
							configurable : true
						})	
					}
				})
			}
			else
			{
				if ((textbox.attr('class')=="textbox"||textbox.attr('class')=="textarea")&&textbox.val()!="")
				{
					Object.defineProperty(ResObj, "Q"+i, {
						value:textbox.val(),
						writable : true,
						enumerable : true
					})	
				}
				else
				{
					Object.defineProperty(ResObj, "Q"+i, {
						value:checkBoxValue,
						writable : true,
						enumerable : true
					})
				}
			}
		}

		if (type=="总分")
		{
			var typeE="allscore";
		}
		else if (type=="等级")
		{
			var typeE="grade";
		}
		else
		{
			var typeE="result";
		}
		$('#'+typeE).text(ServerCallMethod("web.CDSS.Access.AssConResCondi","GetResByConf",id+"[A]"+type+"[A]"+JSON.stringify(ResObj)));
	
	}
	//计算方法
	CalculateMethod=function(method,special){
		if(method)
		{
			switch (method) {
			    case "getTheCheckBoxValue":
					getTheCheckBoxValue();
			        break;
			    case "getAverageValue":
			        getAverageValue();
			        break;
			    case "getMaxValue":
			        getMaxValue();
			        break;
			    default:
					break;
			}
		}
		if(special)
		{
			for(i=0;i<special.split(",").length;i++)
			{
				SpecialCalculate(special.split(",")[i]);
			}
		}
		return;
	}
	
    //省立 患者入住ICU的主要疾病分值(单选框) 只能有一个选项
    ClearOtherOption = function(e,value) {
        if (value==true)
        {
            var checkbox = $("#layoutcenter input:checked");
            checkbox.each(function() {
                if (e.target.id!==$(this).attr("id"))
                {
                    $(this).radio("setValue", false);
                }  
            })
            
        }
        var checkBoxValue = 0;
        var checkbox1 = $("#layoutcenter input:checked");
        checkbox1.each(function() {
            checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 10; //减0 转换成number类型
        })
        $("#allscore").text(checkBoxValue / 10);
		var rankHtml=ServerCallMethod("web.CDSS.Access.Assessment","GetDescByIdScore",id+"[A]"+checkBoxValue/10);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);   
    }
	
    // 省立计算 APACHE II评分表 的群体患者死亡率
    PatientMortality=function (checkBoxValue){
        if ((PatientUserInfo!=="") & (PatientUserInfo!=undefined)&(AssDesc=="APACHE II评分表"))
        {
            var addoperaflag=false
            var checkbox = $("#layoutcenter input:checked");
            checkbox.each(function() {
               if($(this).attr("label").indexOf("急诊手术患者")!==-1) 
                {
                    addoperaflag=true
                }
            })
			var desc=ServerCallMethod("web.CDSS.Access.Assessment","GetDescByIdScorePatient",id+"[A]"+checkBoxValue/10+"[A]"+PatientUserInfo+"[A]"+addoperaflag);
            $("#desc").val(desc);
        }
    }
	
    //Oswestry功能障碍指数问卷表（ODI） 单独计算方式
    OswestryScore = function() {
        //Oswestry功能障碍指数问卷表（ODI）只有单选框
        var checkBoxValue = 0;
        var checkbox = $("#layoutcenter input:checked");
        var checkboxnum=0
        checkbox.each(function() {
            checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0);  //减0 转换成number类型
            checkboxnum=checkboxnum+1
        })
        if (checkboxnum!==0)
        {
            var value = Number((checkBoxValue / 5)/checkboxnum* 100 ).toFixed(1);
            value+="%";
            $("#allscore").text(value);

        }
        else
        {
            $("#allscore").text(0)  
        }
		var rankHtml=ServerCallMethod("web.CDSS.Access.Assessment","GetDescByIdScore",id+"[A]"+checkBoxValue/10);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);
		//PatientMortality(checkBoxValue);
    }
	var typeflag=ServerCallMethod("web.CDSS.Access.Assessment","GetAssessmentType",id);
    //获得该评估表的基本信息
    if (id !== null)
    {
		AssDesc = ServerCallMethod("web.CDSS.Access.Assessment", "getMKBABDesc", id);
        var AssBasicInfo = ServerCallMethod("web.CDSS.Access.Assessment", "GetAssBasicInfo", id);
    	AssBasicInfo=eval('(' + AssBasicInfo + ')');
    	//根据配置信息按需展示结果
	    if(AssBasicInfo[0].ShowScoreFlag == '1')
	    {
		   $('#ScoreCont').css('display','none')
		}
		if(AssBasicInfo[0].ShowConclusionFlag == '1')
		{
			$('#ResultCont').css('display','none')
		    //$('#GradeCont').css('display','none');
		}
		if(AssBasicInfo[0].ShowResultFlag == '1')
		{
		    //$('#ResultCont').css('display','none');
			$('#GradeCont').css('display','none')
		}
		if(AssBasicInfo[0].ShowResultFlag == '1' && AssBasicInfo[0].ShowScoreFlag == '1' && AssBasicInfo[0].ShowConclusionFlag == '1' && typeflag!=1)
	    {
		    $('#divassess').css('display','none')
		}
	}
    if (sdflag == null) sdflag = "";
    if (sdflag != "") 
	{
		if (sdflag.indexOf("cdss")==-1)
		{
			var centerHtml = $.m({
				ClassName: 'web.CDSS.Access.Assessment',
				MethodName: 'CreateAssessmentHtmlNew',
				id: id,
				PatientUserInfo:PatientUserInfo
			}, false);
		}
		else
		{
			var centerHtml = ServerCallMethod("web.CDSS.TreatDecision.Assessment","CreateAssessmentHtmlNew",id+"[A]"+PatientUserInfo);
		}
        //var centerHtml = ServerCallMethod("web.CDSS.Access.Assessment","CreateAssessmentHtmlNew",id+"[A]"+PatientUserInfo);
        var  hh = $("<div id='allcontent' class='allcontent'>" + centerHtml + "</div>")
        $("#layoutcenter").append(hh);
		$("#layoutcenter").css("overflow-x","hidden")
		/*$('.allcontent').find('label').each(function(){
	        var nHtml = $(this).html()
	        var nLength = 0
	    	if(nHtml.indexOf('\n')>-1){
		    	var nLength = nHtml.split('\n').length
		    }
		    $(this).parent().css({height:$(this).parent().height()+(nLength-2)*20+"px"})
	    })*/
	    var method=ServerCallMethod("web.CDSS.Access.Assessment","GetCalcaluteType",id);
	    var special=ServerCallMethod("web.CDSS.Access.Assessment","SpecialItem",id);
	    if (method!="")
	    {
	    	switch (method) {
			    case "Sum":
					var method_Cal="getTheCheckBoxValue";
			        break;
			    case "Avg":
			        var method_Cal="getAverageValue";
			        break;
			    case "Max":
			        var method_Cal="getMaxValue";
			        break;
			    case "Special":
			    	var method_Cal="SpecialCalculate";
			    default:
					break;
			}
	    }
	    else
	    {
			var method_Cal="getTheCheckBoxValue"
		}
	    hh.find('.shdh').each(function(){
			$(this).combobox({
				onChange:function(e,value){CalculateMethod(method_Cal,special)},
				onSelect:function(e,value){CheckOption($(this));}
			})
		})
		CalculateMethod(method_Cal,special)			//计算总分
		$('.titleh3').each(function(){
			var h3text=$(this).text().replace(/[0-9]+./g,"")
			if (h3text[1]==" ")
			{
				$(this).next().find("div").css("padding-top","0")
				$(this).next().find("li").css("margin-top","0")
				$(this).next().find("li").css("padding-top","0")
			}
		})
		//$(".contentul li").css("margin-top","0")
		//$(".contentul li").css("padding-top","0")
		//$(".contentul").css("padding-top","0")
		/*if(typeflag==1)
		{
			$('#ResultCont').css('float','left')
			//$('#divassess').append("<div><a href='javascript:void(0)' style='float:right' id='HistoryRes'>点击查看历史评分记录</a><div>");
		}*/
		if(sdflag=='Y')
		{
			$("#Savebtn").append("<a href='#'' style='position:absolute;right:120px' class='hisui-linkbutton' iconCls='icon-w-save' data-options='plain:false' id='btnSave2'>保存</a>")
		}
        if (sdflag == "cdss") {
            $("#Savebtn").append("<a href='#'' style='position:absolute;right:120px' class='hisui-linkbutton' iconCls='icon-w-save' data-options='plain:false' id='btnSave2'>保存</a>");
			if(tkMakeServerCall("websys.Conversions","IsValidMethodName","web.DHCXMLPConfig","LODOPInit")){
				$("#Savebtn").append("<a href='#'' style='position:absolute;right:30px' class='hisui-linkbutton' iconCls='icon-print' data-options='plain:true' id='printCss'>打印</a>")
			}
        }else if (sdflag.indexOf("cdssreuse") != -1){
            if (editflag == "editable")
            {
                $("#Savebtn").append("<a style='position:absolute;right:210px' href='#'' class='hisui-linkbutton' iconCls='icon-w-save' data-options='plain:false' onclick='EditRatingData(\""+sdflag+"\")' id='btnSave1'>修改</a><a href='#'' style='position:absolute;right:120px' class='hisui-linkbutton' iconCls='icon-w-add'  data-options='plain:false' id='btnSave2'>另存</a>")
            }else{
                $("#Savebtn").append("<a href='#'' style='position:absolute;right:120px' class='hisui-linkbutton' iconCls='icon-w-save' data-options='plain:false' id='btnSave2'>保存</a>")
            }
            if(tkMakeServerCall("websys.Conversions","IsValidMethodName","web.DHCXMLPConfig","LODOPInit")){
	        	$("#Savebtn").append("<a href='#'' style='position:absolute;right:30px' class='hisui-linkbutton' iconCls='icon-w-print' data-options='plain:false' id='printCss'>打印</a>")
	        }
        }
        $.parser.parse(); //渲染hisui 样式 
        if ((sdflag == "sd") || (sdflag == "cdss") || (sdflag.indexOf("cdssreuse") != -1)) {
            var str=GetURLParams("allvalue");
            var remarks=decodeURIComponent(GetURLParams("remarks"));
			if (remarks == "null")
			{
				remarks=""
			}
            if (!!str) {
                allvalue = str.split("[%AND]");
            } else {
                allvalue = [];
            }
            $.each(allvalue, function(index, value) {
                if (value != "") {
                    var $thisid = value.split("[iAndv]")[0];
                    var $thisval = value.split("[iAndv]")[1];
                    var $thistype = $thisid.split("_")[0];
                    if ($thistype == "C") {
                        $("#" + $thisid).find("select").combobox('setValue', $thisval);
                    }
                    if ($thistype == "R") {
                        $("#" + $thisid).find("input[value='" + $thisval + "']").radio("setValue", true);
                    }
                    if ($thistype == "CB") {
                        if ($thisval != "") {
                            var $thisvalnew1 = $thisval.split("[CBVa]");
                        }
                        $("#" + $thisid).find("input").each(function(index) {
                            var $thisvalnew2 = $thisvalnew1[index + 1];
                            $("#" + $thisid).find("input[value='" + $thisvalnew2 + "']").checkbox("setValue", true);
                        })
                    }
                    if (($thistype == "TX")) {
                        $("#" + $thisid).find("input").val($thisval);
                    }
                    if ($thistype == "TA") {
                        $("#" + $thisid).find("textarea").val($thisval);
                    }
                }
            })
            if (remarks !=null){
                $("#desc").val(remarks);
            }else{
                $("#desc").val("");
            }
            
        }
        //$(".hisui-checkbox").removeAttr('id');
    }
	//历史评分记录
	$('#HistoryRes').click(function (e) {
		if (sdflag.indexOf("cdss")==-1)
		{
			var HisHtml = $.m({
				ClassName: 'web.CDSS.Access.Assessment',
				MethodName: 'HistoryAssessmentHtml',
				id: id,
				PatientUserInfo:PatientUserInfo
			}, false);
		}
		else
		{
			var HisHtml=ServerCallMethod("web.CDSS.Access.Assessment","HistoryAssessmentHtml",id+"[A]"+PatientUserInfo);
		}
		$("#HisWin").show();
		var myWin = $HUI.window("#HisWin", {
			iconCls: 'icon-w-read',
			resizable: true,
			title: '历史评分记录',
			width:1000, 
			height:(document.body.clientHeight-60),  //根据浏览器高度
			modal: true,
			maximizable: false,
			minimizable: false,
			collapsible: false,
			content: "<div style='background-color:#FFFFFF' data-options='region:'center',border:false'>"+HisHtml+"</div>",
			buttonAlign: 'center'
		});
	})
	
    $("#btnSave").click(function(e) {
        var allvalue = GetAllValue();
        $("#allvalue").val(allvalue);
        if (CheckAll() == "true") {
            getTheCheckBoxValue();
        };
		if (editflag!=""||editflag!=null)
		{
			if (editflag == "first")
			{
				parent.parent.RequestRatingScale(PatientUserInfo,"","","");
			}else{
				parent.RequestRatingScale(PatientUserInfo,"","",""); 
			}
		}
    })
    /*$('#btnSave1').click(function(e){
        alert(1);
    })*/
    // 修改原有评分别结构  edito：范文凯
    EditRatingData = function(Str){
        var allvalue = GetAllValue();
        var score = $("#allscore").text();
        var result = $("#result").text();
        var grade = $("#grade").text();
        var desc = $("#desc").val();
        if (score == "") {
            $.messager.alert("提示信息", "还未计算总分,无法保存结果", "info");
            return;
        }
		var Data=ServerCallMethod("web.CDSS.TreatDecision.RatingScale","EditRatingData",PatientUserInfo + "[A]" + score + "[A]" + result + "[A]" + allvalue + "[A]" + grade + "[A]" + id + "[A]" + desc + "[A]" + Str);
		AferEditRatingData2(Data);
        closeCDSS2();
    }
    
    //港大 丁亚男 
    AferEditRatingData=function(Data)
    {
        var Data = eval('(' + Data + ')');
        if (Data.success == "true")
        {
			/*$.messager.popover({
				msg: '评估记录已成功保存!',
				type: 'success',
				timeout: 1000
			});*/    
			//dyn edit
			if (editflag!=""||editflag!=null)
			{
				if (editflag == "first")
				{
					parent.parent.RequestRatingScale(PatientUserInfo,"",true);													   
				}else{
					parent.RequestRatingScale(PatientUserInfo,"",true);
				}
			}
        }
        else
        {
            var errorMsg ="提交失败！"
            if (data.errorinfo) {
                errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
            }
            $.messager.alert('操作提示',errorMsg,"error");
        }
    }
    function closeCDSS2(){
		if (sdflag.indexOf("cdss")!=-1)
		{
			if (typeof window.parent.document.getElementById("htmlContainer").contentWindow.updateRatingScale == 'undefined')
			{
				window.parent.document.getElementById("htmlContainer").contentWindow.postMessage('closeRatingScale','*')
			}
			else{
				window.parent.document.getElementById("htmlContainer").contentWindow.updateRatingScale()
			}
			var Info = { 'action': 'INITIALIZE_PATIENT_INFORMATION', 'data': window.parent.PatientUserInfo }
    		window.parent.document.getElementById("htmlContainer").contentWindow.postMessage(Info, '*')
			window.parent.$("#encyclopedia_win").window('close')
			//window.close()
		}
		return;
	}
    //范文凯
    AferEditRatingData2=function(Data)
    {
        //var Data = eval('(' + Data + ')');
        /*if (Data[0].success == "true")
        {
            $.messager.popover({
            msg: '评估记录已成功保存!',
            type: 'success',
            timeout: 1000
            });
        }*/
        //setTimeout(parent.showtable("急性阑尾炎"),5000);
        //fwkadd
        closeCDSS2();
		if (editflag!=""||editflag!=null)
		{
			if (editflag == "first")
			{
				parent.parent.RequestRatingScale(PatientUserInfo,"","","");
				//parent.showtable("timeline");
				var idname = parent.parent.$('#Assessment').parent().parent().parent().attr('id');
				$('#'+idname, window.parent.parent.document).hide();  
			}
			else
			{
				parent.RequestRatingScale(PatientUserInfo,"","","");
				//parent.showtable("timeline");
				var idname = parent.$('#Assessment').parent().parent().parent().attr('id');
				$('#'+idname, window.parent.document).hide();   
			}
		}
    } 
	$("#btnSave2").click(function (e) {
        var allvalue = GetAllValue();
        var score = $("#allscore").text();
        var result = $("#result").text();
        var grade = $("#grade").text();
        var desc = $("#desc").val();
        var scflag=eval(ServerCallMethod("web.CDSS.Access.Assessment","GetAssBasicInfo",id))[0].ShowScoreFlag
        if ((scflag==0)&&(score == "")) {
            $.messager.alert("提示信息", "还未计算总分,无法保存结果", "info");
            return
        }
		var lastscore=ServerCallMethod("web.CDSS.Access.Assessment","GetLastRatingSocre",PatientUserInfo+"[A]"+id);
		if (lastscore==allvalue)
		{
			$.messager.confirm('提示',"本次评分各分值与上次评分相同确认保存？", function(r) {
				if (r) {
					//if (sdflag == "cdss") {
						var Data=ServerCallMethod("web.CDSS.TreatDecision.RatingScale","SaveRatingData",PatientUserInfo + "[A]" + score + "[A]" + result + "[A]" + allvalue + "[A]" + grade + "[A]" + id + "[A]" + desc);
						$.messager.popover({
						msg: '评估记录已成功保存!',
						type: 'success',
						timeout: 1000
						});
					//}
				}
			})
		}
		else
		{
			var Data=ServerCallMethod("web.CDSS.TreatDecision.RatingScale","SaveRatingData",PatientUserInfo + "[A]" + score + "[A]" + result + "[A]" + allvalue + "[A]" + grade + "[A]" + id + "[A]" + desc);
			$.messager.popover({
			msg: '评估记录已成功保存!',
			type: 'success',
			timeout: 1000
			});
		}
		closeCDSS2()
    })
    //获得所有选择的值
    GetAllValue = function() {
        var allvalueid = [];
        $(".contentul").each(function() {
            var $thisid = $(this).attr("id");
            var $thistype = $thisid.split("_")[0];
            var $thisval = ""
            if ($thistype == "C") {
                $thisval = $("#" + $thisid).find(".combo-value").val();
            }
            if ($thistype == "R") {
                $thisval = $("#" + $thisid).find("input:checked").val();
            }
            if ($thistype == "CB") {
                $("#" + $thisid).find("input:checked").each(function(index) {
                    $thisval = $thisval + "[CBVa]" + $("#" + $thisid).find("input:checked").eq(index).val();
                })
            }
            if (($thistype == "TX")) {
                $thisval = $("#" + $thisid).find("input").val();
            }
            if ($thistype == "TA") {
                $thisval = $("#" + $thisid).find("textarea").val();
            }
            allvalueid.push($thisid + "[iAndv]" + $thisval)
        })
		$(".txtcontentul").each(function() {
		    var $thisid = $(this).attr("id");
		    var $thistype = $thisid.split("_")[0];
		    var $thisval = "_"
		    if (($thistype == "TX")) {
		        $thisval = "_"+$("#" + $thisid).find("input").val();
		    }
		    if ($thistype == "TA") {
		        $thisval = $("#" + $thisid).find("textarea").val();
		    }
		    allvalueid.push($thisid + "[iAndv]" + $thisval)
		})
        return allvalueid.join("[%AND]");
    }
    //判断是否选完
    CheckAll = function() {
        var rt = "true"
        //判断复选框是否选一个
        var boxradio = [];
        $(".contentul").each(function() {
            //筛选出单选和复选的id
            var $thisid = $(this).attr("id")
            if (($thisid.indexOf("R") != -1) || ($thisid.indexOf("CB") != -1)) {
                boxradio.push($thisid)
            }
        })
        var flagradioarrey = [];
        $.each(boxradio, function(index, value) {
            flagradioarrey[index] = "false";
            $("#" + value).find(".radio").each(function() {
                if ($(this).hasClass("checked")) {
                    flagradioarrey[index] = "true";
                }
            })
            $("#" + value).find(".checkbox").each(function() {
                if ($(this).hasClass("checked")) {
                    flagradioarrey[index] = "true";
                }
            })
        })
        if (flagradioarrey.indexOf("false") != -1) {
            $.messager.alert("提示信息", "还有未填写题目,请选完后计算总分", "info");
            rt = "false";
            $("#grade").text("");
            $("#result").text("");
            $("#allscore").text("");
        }
        return rt
    }
    if($('#printCss')){
	    var LODOP; //声明为全局变量
	    $('#printCss').click(function (e) {
	        //alert(window.location.href)
	        refreshData()
		   	LODOP=getLodop();  	
			//var strStyleCSS="<link href='../scripts_lib/hisui-0.1.0/dist/css/hisui.css' type='text/css' rel='stylesheet'>";
			var strBodyStyle="<style>"+document.getElementById("styleLable").innerHTML+"</style>";
	        //var UrlLink=".."
	        var WebServerlLink=ServerCallMethod("web.CDSS.Access.Assessment", "GetWebServerLink")
	        var UrlLink="http://"+WebServerlLink //医为浏览器，需要写成这种路径才能打印出来  "http://172.18.15.30/imedical/web"
	        //添加img元素
	        $('#layoutcenter').find('label.radio').each(function () {
	            if ($(this).hasClass('checked')) {//选中的单选框\
	            	//医为浏览器，需要写成以下路径才能打印出来
	                $("<img class='imgRemove' style='margin-right:10px;line-height:16px' src='"+UrlLink+"/scripts/bdp/Framework/icons/radio-checked.png'>").prependTo($(this))
	            } else {//未选中的单选框
	                $("<img class='imgRemove' style='margin-right:10px;line-height:16px' src='"+UrlLink+"/scripts/bdp/Framework/icons/radio.png'>").prependTo($(this))
	            }
	        })
	        $('#layoutcenter').find('label.checkbox').each(function () {
	            if ($(this).hasClass('checked')) {//选中的多选框
	                $("<img class='imgRemove' style='margin-right:10px;line-height:16px' src='"+UrlLink+"/scripts/bdp/Framework/icons/checkbox-checked.png'>").prependTo($(this))
	            } else {//未选中的多选框
	                $("<img class='imgRemove' style='margin-right:10px;line-height:16px' src='"+UrlLink+"/scripts/bdp/Framework/icons/checkbox.png'>").prependTo($(this))
	            }
	        })
	        //隐藏保存结果按钮
	        $('#btnSave2').hide()
	        if($('#btnSave1')){
		        $('#btnSave1').hide()
		    }
	        
	        $('#printCss').hide()
	        //隐藏文本框和输入框的边框
	        $('#layoutcenter').find('.textbox,.textarea').each(function(){
		        $(this).css({'border':'0px','overflow-y':'hidden'})
		    })
	        var mainHTML = document.getElementById("layoutcenter").innerHTML
	        //移除img元素
	        $('#layoutcenter').find('.imgRemove').each(function () {
	            $(this).remove()
	        })
	        //打印开始
	        var strFormHtml = strBodyStyle + "<body>" + $(mainHTML).html() + document.getElementById("footer").innerHTML + "</body>";
	        LODOP.PRINT_INIT("评估表打印");
	        //LODOP.SET_PRINT_STYLEA(0,"TextNeatRow",true);
			//LODOP.ADD_PRINT_TEXT(50,50,260,39,"打印与显示样式一致：");
			LODOP.ADD_PRINT_HTM(0,0,"90%","BottomMargin:1.5cm",strFormHtml);//上左右下
			
			//页脚和页码
			LODOP.ADD_PRINT_LINE("94%",23,"94%",760,0,1);
			LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
			LODOP.SET_PRINT_STYLEA(0,"Horient",3);
			LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
			//获取页脚描述
			var footDesc = tkMakeServerCall("web.CDSS.Access.Assessment","GetFooterById",id)
	        LODOP.ADD_PRINT_TEXT("95%", 37, 144, 22, footDesc);
	        LODOP.SET_PRINT_STYLEA(0,"ItemType",1);
			LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
			LODOP.ADD_PRINT_TEXT("95%",700,165,22,"第#页/共&页");
			LODOP.SET_PRINT_STYLEA(0,"ItemType",2);
			LODOP.SET_PRINT_STYLEA(0,"Horient",1);
			LODOP.SET_PRINT_STYLEA(0,"Vorient",1);
			LODOP.SET_PREVIEW_WINDOW(0,0,0,0,0,""); //隐藏工具条，设置适高显示  第一个参数0为适高 第二个0是隐藏下方工具条
			//LODOP.SET_PRINT_STYLEA(0,"HtmWaitMilSecs",1000);//延迟100毫秒

	        LODOP.PREVIEW();
	        //展示保存结果按钮
	        $('#btnSave2').show()
	        if($('#btnSave1')){
		        $('#btnSave1').show()
		    }
	        $('#printCss').show()
	        $('#layoutcenter').find('.textbox,textarea').each(function(){
		    	$(this).css({'border':'1px solid #95B8E7','overflow-y':'scroll'})
		    })
		})


	}
	function refreshData(){ //让innerHTML获取的内容包含input和select(option)的最新值
		var allInputObject=document.body.getElementsByTagName("input");
		for (i = 0; i < allInputObject.length; i++) {
			if(allInputObject[i].type=="checkbox")  {
		        	if (allInputObject[i].checked ) 
                	   	allInputObject[i].setAttribute("checked","checked"); 
                	   	else
				        allInputObject[i].removeAttribute("checked");
        	} else 	if(allInputObject[i].type=="radio")  {
		        	if (allInputObject[i].checked ) 
                	   	allInputObject[i].setAttribute("checked","checked"); 
                	   	else
				        allInputObject[i].removeAttribute("checked");
        	}else allInputObject[i].setAttribute("value",allInputObject[i].value);
		};
		for (i = 0; i < document.getElementsByTagName("select").length; i++) {
		    var sl=document.getElementsByTagName("select")[i];
		    for (j = 0; j < sl.options.length; j++) {
		    if (sl.options[j].selected) 
                     	sl.options[j].setAttribute("selected","selected");
			else sl.options[j]=new Option(sl.options[j].text,sl.options[j].value);
		    };
		};
	};   

})
