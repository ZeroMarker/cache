var patientInfo="",
    operationInfo="",
    anaestInfo="",
    filePath="";
    opaId=""
    Ifsinge=0
 $.ajaxSetup({
  async: false
  })
  
$(document).ready(function(){
        var  EpisodeID=getUrlParam("EpisodeID")
     $.post("dhcclinic.jquery.printmethod.csp",{
                ClassName:"web.DHCANOPCom",
                MethodName:"GetOpaIdStr",             
                Arg1:EpisodeID,
                ArgCnt:"1"
                },function(opaIdStr){
                    opaIdStr=opaIdStr.replace(/[\r\n ]/g, '');
                     var count=opaIdStr.split("^").length;
                     for(i=0;i<count;i++)
                     {
                         
                         opaId=opaIdStr.split("^")[i];
                         if(opaId=="")continue;
      
                           printCheckingRecord1();
                           //$("#countRecord").datagrid("reload");
                           printCheckingRecord();
                           //parent.finishOneItemJobAsyn();
                      } 
                      //setTimeout("parent.printNext();", 3000)
                    }
                    )
                    //setTimeout("parent.printNext();", 3000)
})
function   getUrlParam(name)
             {      
               var   reg   =   new   RegExp("(^|&)"+   name   +"=([^&]*)(&|$)");      
               var   r   =   window.location.search.substr(1).match(reg);      
               if   (r!=null)  
               return   unescape(r[2]);   
               return   "";      
             } 
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


function printCheckingRecord1(){
    //self.moveTo(0,0);
    //self.resize(screen.availWidth,screen.availHeight);

    $("#countRecordInfo").panel({
        title:"清点记录",
        iconCls:'icon-opercount',
        width:480,
        //height:800,
        style:{"font-family":"微软雅黑","float":"left","padding":"0px 5px 5px 0px"},
        collapsible:true
    });
    $("#packageInfo").panel({
        title:"无菌包检查情况",
        iconCls:'icon-packinfo',
        width:630,
        height:320,
        style:{"font-family":"微软雅黑","padding":"0"},
        collapsible:true
    });
    /*
    $("#patientInfo").panel({
        title:"输血",
        iconCls:'icon-bloodinfo',
        width:310,
        height:340,
        style:{"font-family":"微软雅黑","float":"left","padding":"0px 0px 5px 0px"},
        collapsible:true
        //display:none
    });*/
    
    $("#signInfo").panel({
        title:"签名",
        iconCls:'icon-signinfo',
        width:300,
        height:340,
        style:{"font-family":"微软雅黑","float":"left","padding":"0px 0px 5px 5px"},
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
            {field:"PackDesc",title:"名称",width:120},
            {field:"SterilizingDate",title:"灭菌日期",width:100},
            {field:"SterilizingTime",title:"灭菌时间",width:80},
            {field:"ExpiredDate",title:"失效日期",width:100},
            {field:"ExpiredTime",title:"失效时间",width:100},
            {field:"QualifiedDesc",title:"失效与否",width:80},
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
    
    $("#countItem").combobox({
        valueField:"tOPCountId",
        textField:"OPCountDesc"
    });
    $.post("dhcclinic.jquery.printmethod.csp",{ClassName:"websys.Conversions",MethodName:"DateFormat",ArgCnt:"0"},
    function(data){
        showfamat=data
    });
    
    //取病人信息
    $.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindPatientInfo",Arg1:opaId,ArgCnt:"1"},
        function(data){
            patientInfo=data.rows[0];
            
            $("#patName").text("患者姓名："+patientInfo.Name);
            $("#gender").text("性别："+patientInfo.Gender);
            $("#age").text("年龄："+patientInfo.Age);
            $("#dept").text("科别："+patientInfo.Location);
            $("#medicareNo").text("住院号："+patientInfo.MedicareNo);
            $("#bedNo").text("床号："+patientInfo.BedCode);
            
            bannerInfo="患者姓名："+patientInfo.Name+"  性别："+patientInfo.Gender+"  年龄："+patientInfo.Age+"  科别："+patientInfo.Location;
    //-----丁延丽+20161025+不挪位置，打开次数不一样，title显示不同
    if(bannerInfo!="")
    {
        //取手术信息
        $.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindOperationInfo",Arg1:opaId,ArgCnt:"1"},
            function(data){
                operationInfo=data.rows[0];
                $("#operationDate").text("手术日期："+operationInfo.OperationDate);
                $("#operation").text("手术名称："+operationInfo.Operation);
                bannerInfo=bannerInfo+"  手术名称："+operationInfo.Operation;
                $(document).attr("title","手术清点记录-"+bannerInfo);
        },"json");
    }
    //---------end
    
    },"json").error(function(result){
    });
    /*
    //取手术信息
    $.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindOperationInfo",Arg1:opaId,ArgCnt:"1"},
        function(data){
            operationInfo=data.rows[0];
            $("#operationDate").text("手术日期："+operationInfo.OperationDate);
            $("#operation").text("手术名称："+operationInfo.Operation);
            bannerInfo+="  手术名称："+operationInfo.Operation;
            $(document).attr("title","手术清点记录-"+bannerInfo);
    },"json");
    */
    //取麻醉信息
    $.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindAnaestInfo",Arg1:opaId,ArgCnt:"1"},
        function(data){
            anaestInfo=data.rows[0];
            $("#planAnaestMethod").text("拟麻醉方式："+anaestInfo.PlanAnaMethod);
    },"json");
    //alert(bannerInfo);
   
    
    //获取已经保存的值
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
    
    // 打印模板路径
    $.post("dhcclinic.jquery.printmethod.csp",{ClassName:"web.DHCClinicCom",MethodName:"GetPath",ArgCnt:"0"},
    function(data){
        filePath=data;
    });
    
}
function printCheckingRecord(){
        
    //操作excel
    var excel=null,
        workBook=null,
        sheet=null;
    try{
        excel=new ActiveXObject("Excel.Application");
    }
    catch(e){
        $.messager.alert("错误","计算机未安装Excel电子表格程序，请先安装！","error");
    }
    
    var fileName=filePath.replace(/[\r\n]/g,"").replace(/\ +/g,"")+"DHCANOPCountRecord.xlsx";
    //var fileName="http://10.10.100.10/dthealth/med/Results/Template/DHCANOPCountRecord.xlsx"
    try{
        workBook=excel.Workbooks.open(fileName);
        sheet=workBook.Worksheets(1);
        
        sheet.Range("A1").Value= patientInfo.hospitalDesc+"手术清点单";  //医院名称  YuanLin 20170828
        //病人信息  
        sheet.Range("G2").Value= patientInfo.Name;  //姓名
        sheet.Range("K2").Value= patientInfo.Gender;    //性别
        sheet.Range("M2").Value= patientInfo.Age;   //年龄
        //sheet.Range("E2").Value= patientInfo.BedCode; //床号
        sheet.Range("C2").Value= patientInfo.Location;  //科室
        //var opaId=getQueryString("opaId");
        $.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCClinicAdmission",QueryName:"FindOperationInfo",Arg1:opaId,ArgCnt:"1"},
            function(data){
                operationInfo=data.rows[0];
        },"json");
        sheet.Range("C3").Value= operationInfo.OperationDate;   //手术日期
      
        sheet.Range("G3").Value= operationInfo.Operation;   //手术名称
        sheet.Range("C4").Value= patientInfo.RegisterNo;    //登记号
        /*
        sheet.Range("C4").Value= $("#OPC_TransBlood_BloodType").val();  //血型
        sheet.Range("F4").Value= $("#OPC_TransBlood_BloodDesc").val();  //成分
        sheet.Range("J4").Value= $("#OPC_TransBlood_BloodVolume").val();    //血量
        */
        var rows;   //=$("#countRecord").datagrid("getRows");
        $.post("dhcclinic.jquery.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANCOPCount",QueryName:"FindTypeSel",Arg1:"",
            Arg2:opaId,
            Arg3:"",
            ArgCnt:"3"},
            function(data){
                rows=data.rows;
        },"json");
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
                //alert(countdesc+"数量前后不一致,请核对数据!");
                //return;
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
        
        sheet.Range("F29").Value= $("#OPC_ScrubNurseSign").val();
        sheet.Range("F30").Value= $("#OPC_XScrubNurseSign").val();
        //sheet.Range("F31").Value= $("#OPC_PreCloseScrubNurseSign").val();
        sheet.Range("J29").Value= $("#OPC_CirculNurseSign").val();
        sheet.Range("J30").Value= $("#OPC_XCirculNurseSign").val();
        //sheet.Range("J31").Value= $("#OPC_PostCloseCirculNurseSign").val();
        
        sheet=workBook.Worksheets(2);
        sheet.Select(); 
        /*
        //病人信息  
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
        $.messager.alert("错误","未找到打印模板，请确认打印模板的路径是否正确！"+e.description,"error");
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
        $.post("dhcclinic.jquery.printmethod.csp?time="+(new Date()).getTime(),{ClassName:"web.DHCANOPArrangeExtend",MethodName:"SaveArrangeExtend",Arg1:opaId,Arg2:value,Arg3:userId,ArgCnt:"3"},
        function(data){
            if(data.Trim()==""){
                $.messager.alert("提示","成功保存数据！","info");
                
            }
            else
            {
                $.messager.alert("错误","保存数据失败！原因："+data,"error");
            }
            
        });
    }/*/
    if(value && value!=""){
        $.ajax({
            async:false,
            type:"post",
            url:"dhcclinic.jquery.printmethod.csp?time="+(new Date()).getTime(),
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
                    $.messager.alert("错误","保存数据失败！原因："+data,"error");
                }
            }
        });
    }
    return saveRet
}
   $.fn.datebox.defaults.formatter = function(date){
       //##class(websys.Conversions).DateFormat()
       var formatnum=""
       $.post("dhcclinic.jquery.printmethod.csp",{ClassName:"websys.Conversions",MethodName:"DateFormat",ArgCnt:"0"},
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