function EMRLinkView(opts){
    this.options=$.extend({
        width:276,
        height:170,
        needsave:false,
        entry:false
    },opts);
    this.init();
}

EMRLinkView.prototype={
    /**
     * 关联病历面板初始化
     */
    init:function(){
        this.dom=$("<div></div>").appendTo("body");
        this.EMRLinkForm=$("<form method='post'></form>").appendTo(this.dom);
        this.initDialog();
        this.initEMRLinkForm();
    },

    /**
     * 初始化关联病历对话框
     */
    initDialog:function(){
        var _this=this;
        this.dom.dialog({
            title:this.options.title,
            width:this.options.width,
            //height:this.options.height,
            closed:true,
            modal:true,
            iconCls:"icon-w-pen-paper",
            buttons:[{
                id:"btnConfirm",
                text:"确认",
                handler:function(){
                    _this.linkRecords=_this.getLinkedDatas();
                    if(!_this.options.app){
                        _this.save();
                    }else if(!_this.linkRecords || _this.linkRecords.length<=0){
                        $.messager.alert("提示","未关联任何电子病历记录，请关联后再确定。","warning");
                    }else{
	                	_this.options.needsave=true;
	                	_this.options.entry=true;
                        _this.close();
                    }
                }
            },{
                text:"取消",
                handler:function(){
                    _this.exit();
                }
            }],
            onOpen:function(){
                _this.reload();
                if(_this.options.openCallBack)
                    _this.options.openCallBack();
            },
            onClose:function(){
                if(_this.options.closeCallBack)
                    _this.linkRecords=_this.getLinkedDatas();
                    _this.options.closeCallBack({
                        linkRecords:_this.linkRecords,
	                    needsave:_this.options.needsave,
	    				entry:_this.options.entry
                    });
                if(_this.dom){
                    _this.dom.remove();
                }
            }
        });

        $("#btnConfirm").css({"background":"#21BA45"});
    },

    /**
     * 初始化签名表单
     */
    initEMRLinkForm:function(){
        this.initEMRLinkViewDom();
        
    },

    initEMRLinkViewDom:function(){
        var _this=this;
        var controlDatas=_this.getOperRiskControls();
        _this.EMRLinkForm.empty();
		controlFillIn=[];
		needLinkEMR=false;
        if(controlDatas && controlDatas.length>0){
            var htmlArr=[];
            var AnaMethodFlag=_this.IfLocalAnaMethod(_this.options.prevAnaMethodId,_this.options.SourceType);
            var operClass=_this.getOperClass(_this.options.OperClass);
            for (var i = 0; i < controlDatas.length; i++) {
                LinkEMR=false;
                var controlData = controlDatas[i];
				if(controlData.ControlTypeDesc==="无"){
					continue;
				}
                var operCategoryControl=_this.getOperClass(controlData.OperCategoryControlDesc);
                // 急诊手术是否关联病历文书
                if(_this.options.SourceType==="E" && controlData.Emergency==="on") LinkEMR=true;

                // 择期局部麻醉手术是否关联病历文书
                if((AnaMethodFlag==="Y") && (controlData.LocalAnesthesia==="on")) LinkEMR=true;

                // 手术级别是否关联病历文书
                if(operClass>=operCategoryControl) LinkEMR=true;

				if(controlData.ControlTypeDesc==="禁止"){
					controlFillIn[controlData.Code]=true;
				}
				if(LinkEMR){
                htmlArr.push("<div>");
                htmlArr.push("<div class='form-row' style='margin:0px;padding:10px 10px 0px 10px'>");
                htmlArr.push("<div class='form-title-right5'>");
                htmlArr.push(""+$g(controlData.Description)+"");
                htmlArr.push("</div>");
                htmlArr.push("<div class='form-item-normal' style='margin-right:0px'>");
                htmlArr.push("<select class='hisui-combogrid EMRControl' id='"+controlData.Code+"' Desc='"+controlData.Description+"' ItemType='"+controlData.ItemType+"'></select>");
                htmlArr.push("</div>");
                htmlArr.push("</div>");
                htmlArr.push("</div>");
				needLinkEMR=true;
				}
            }
            _this.EMRLinkForm.append(htmlArr.join(""));
            $(".EMRControl").each(function(index,item){
                var id=$(item).attr("id");
				var ItemType=$(item).attr("ItemType");
                $(item).combogrid({
                    url: ANCSP.DataQuery,
                    onBeforeLoad: function(param) {
                        var DocID=id;
                        param.ClassName="CIS.AN.BL.OperApplication";
                        param.QueryName="GetOperativeRecord",
                        param.Arg1=_this.options.EpisodeID || "";
                        if(!param.Arg1) return false;
                        param.Arg2=_this.options.OPSID;
                        param.Arg3=DocID;
						param.Arg4=ItemType;
						param.ArgCnt=4;
                    },
                    panelWidth:450,
                    idField: "insID",
                    textField: "title",
					editable:false,
                    columns:[[
                        {field:"insID",title:"ID",hidden:true},
                        {field:"title",title:"病历文书",width:120},
                        {field:"creator",title:"创建者",width:60},
                        {field:"happenDate",title:"完成日期",width:80},
                        {field:"happenTime",title:"完成时间",width:80},
                        {field:"isLink",title:"是否关联",width:80,formatter:function(value,row,index){
                            if(value==="0"){
                                return "未关联";
                            }else if (value==="1"){
                                return "已关联"
                            }
                
                            return "";
                        }}
                    ]],
                    mode: "remote"
                });
                var result=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"GetLinkRecordByOpaID",_this.options.EpisodeID,session.OPSID);
        		var StrArr=result.split("^");
        		if(StrArr[0]!=""&&StrArr[1]!=""&&StrArr[2]!=""){
					if (StrArr[2].indexOf("知情同意书")>-1&&id==87) {
						$("#"+id).combogrid("setValue",StrArr[0]);
					}
					else if (StrArr[2].indexOf("术前讨论")>-1&&id==73){
						$("#"+id).combogrid("setValue",StrArr[0]);
					}
					else if (StrArr[2].indexOf("术前小结")>-1&&id==71){
						$("#"+id).combogrid("setValue",StrArr[0]);
					}
	        		//$("#"+StrArr[1]).combogrid("setValue",StrArr[0]);
        		}
            });
        }
    },

    /**
     * 获取手术风险控制
     */
    getOperRiskControls:function(){
        var controlDatas=dhccl.getDatas(ANCSP.DataQuery,{
            ClassName:ANCLS.BLL.CodeQueries,
            QueryName:"FindOperRiskControl",
				Arg1:"",
				Arg2:"5",
				ArgCnt:2
        },"json");
    
        return controlDatas;
    },

    getOperClass:function(operClassStr){
        var retClass=0;
		if(operClassStr){
        var operClassArr=operClassStr.split(",");
        var classDescs=["一级手术","二级手术","三级手术","四级手术"];
        var classes=[1,2,3,4];
        if(operClassArr && operClassArr.length>0){
            for (var i = 0; i < operClassArr.length; i++) {
                const operClassDesc = operClassArr[i];
                if(classDescs.indexOf(operClassDesc)>=0){
                    var operClass=classes[classDescs.indexOf(operClassDesc)];
                    if(operClass>retClass){
                        retClass=operClass;
                    }
                }
            }
        }}

        return retClass;
    },

    /**
     * 取消
     */
    exit:function(){
	    this.options.entry=true;
        this.close();
    },

    /**
     * 重新加载表格配置数据
     */
    reload:function(){
        
    },

    /**
     * 打开对话框
     */
    open:function(){
        this.dom.dialog("open");
    },

    /**
     * 关闭对话框
     */
    close:function(){
        this.dom.dialog("close");
        //this.dom.remove();
    },

    /**
     * 保存病历关联
     */
    save:function(){
        var EMRecords=[];
        $(".EMRControl").each(function(index,item){
            var linkInsID=$(this).combogrid("getValue");
            var title=$(this).combogrid("getText");
            if(linkInsID) EMRecords.push(linkInsID+"#1"+title);
        });
        if(!EMRecords || EMRecords.length<=0){
            $.messager.alert("提示","未关联任何电子病历记录，请关联后再确定。","warning");
            return;
        }
        var EMRRecordStr=EMRecords.join(",");
        var opaId=this.options.OPAID;
        var saveRet=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"LinkEMRecords",opaId,EMRRecordStr);
        if(saveRet.indexOf("S^")===0){
            this.close();
        }else{
            $.messager.alert("提示","关联病历错误，原因："+saveRet,"error");
        }
    },

    getLinkedDatas:function(){
        var EMRecords=[];
        $(".EMRControl").each(function(index,item){
            var linkInsID=$(this).combogrid("getValue");
            var title=$(this).combogrid("getText");
            if(linkInsID) EMRecords.push(linkInsID+"#1#"+title);
        });

        return EMRecords;
    },
    IfLocalAnaMethod:function(AnaMethodId,SourceType){
        var Falg="N";
        var Ret=dhccl.runServerMethodNormal(ANCLS.BLL.OperApplication,"IsLocalAnaMethodById",AnaMethodId);
        if((Ret==="Y")&&(SourceType==="B")) Falg="Y";
        return Falg;
    },
}