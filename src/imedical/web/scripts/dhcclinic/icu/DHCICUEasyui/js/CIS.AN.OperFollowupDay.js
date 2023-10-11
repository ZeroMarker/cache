//20210802
var EpisodeID=getEpisodeByMenu();

var selectRow;
var moudl='<table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">术后身体情况</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>切口出血</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="QKCX1" data-formitem="QKCX" class="hisui-checkbox" label="是"><input type="checkbox" id="QKCX2" data-formitem="QKCX" class="hisui-checkbox" label="否"><input type="hidden" id="QKCX" data-title="切口出血" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>切口疼痛</div><div class="form-item" style="width:320px;margin-left:-5px;"><input type="checkbox" id="QKTT1" data-formitem="QKTT" class="hisui-checkbox" label="无痛"><input type="checkbox" id="QKTT2" data-formitem="QKTT" class="hisui-checkbox" label="轻度痛"><input type="checkbox" id="QKTT3" data-formitem="QKTT" class="hisui-checkbox" label="中度痛"><input type="checkbox" id="QKTT4" data-formitem="QKTT" class="hisui-checkbox" label="重度痛"><input type="checkbox" id="QKTT5" data-formitem="QKTT" class="hisui-checkbox" label="剧痛"><input type="hidden" id="QKTT" data-title="切口疼痛" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>是否发热</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="SFFR1" data-formitem="SFFR" class="hisui-checkbox" label="是"><input type="checkbox" id="SFFR1" data-formitem="SFFR" class="hisui-checkbox" label="否"><input type="hidden" id="SFFR" data-title="是否发热" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>排气/排便</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="PQPB1" data-formitem="PQPB" class="hisui-checkbox" label="异常"><input type="checkbox" id="PQPB2" data-formitem="PQPB" class="hisui-checkbox" label="正常"><input type="hidden" id="PQPB" data-title="排气/排便" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>头痛/晕眩</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="TTYX1" data-formitem="TTYX" class="hisui-checkbox" label="是"><input type="checkbox" id="TTYX2" data-formitem="TTYX" class="hisui-checkbox" label="否"><input type="hidden" id="TTYX" data-title="头痛/晕眩" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>四肢麻木</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="SZMM1" data-formitem="SZMM" class="hisui-checkbox" label="麻木"><input type="checkbox" id="SZMM2" data-formitem="SZMM" class="hisui-checkbox" label="正常"><input type="hidden" id="SZMM" data-title="四肢麻木" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>恶心/呕吐</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="EXOT1" data-formitem="EXOT" class="hisui-checkbox" label="是"><input type="checkbox" id="EXOT2" data-formitem="EXOT" class="hisui-checkbox" label="否"><input type="hidden" id="EXOT" data-title="恶心/呕吐" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>无食欲</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="WSY1" data-formitem="WSY" class="hisui-checkbox" label="是"><input type="checkbox" id="WSY2" data-formitem="WSY" class="hisui-checkbox" label="否"><input type="hidden" id="WSY" data-title="恶心/呕吐" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">生活情况及离院后依从性</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>能正常工作和日常家务</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="GZJW1" data-formitem="GZJW" class="hisui-checkbox" label="是"><input type="checkbox" id="GZJW2" data-formitem="GZJW" class="hisui-checkbox" label="否"><input type="hidden" id="GZJW" data-title="能正常工作和日常家务" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>感觉舒适，能控制情绪</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="GJQX1" data-formitem="GJQX" class="hisui-checkbox" label="是"><input type="checkbox" id="GJQX2" data-formitem="GJQX" class="hisui-checkbox" label="否"><input type="hidden" id="GJQX" data-title="感觉舒适，能控制情绪" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>遵从医嘱服药/活动指导</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="FYHD1" data-formitem="FYHD" class="hisui-checkbox" label="是"><input type="checkbox" id="FYHD2" data-formitem="FYHD" class="hisui-checkbox" label="否"><input type="hidden" id="FYHD" data-title="遵从医嘱服药/活动指导" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>出院后开车饮酒等</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="KCYJ1" data-formitem="KCYJ" class="hisui-checkbox" label="是"><input type="checkbox" id="KCYJ2" data-formitem="KCYJ" class="hisui-checkbox" label="否"><input type="hidden" id="KCYJ" data-title="出院后开车饮酒等" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">服务满意度</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>对日间手术的就医流程</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="JYLC1" data-formitem="JYLC" class="hisui-checkbox" label="满意"><input type="checkbox" id="JYLC2" data-formitem="JYLC" class="hisui-checkbox" label="一般"><input type="checkbox" id="JYLC3" data-formitem="JYLC" class="hisui-checkbox" label="不满意"><input type="hidden" id="JYLC" data-title="对日间手术的就医流程" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>对医护人员的服务态度</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="FWTD1" data-formitem="FWTD" class="hisui-checkbox" label="满意"><input type="checkbox" id="FWTD2" data-formitem="FWTD" class="hisui-checkbox" label="一般"><input type="checkbox" id="FWTD3" data-formitem="FWTD" class="hisui-checkbox" label="不满意"><input type="hidden" id="FWTD" data-title="对医护人员的服务态度" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>对本次手术的治疗效果</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="ZLXG1" data-formitem="ZLXG" class="hisui-checkbox" label="满意"><input type="checkbox" id="ZLXG2" data-formitem="ZLXG" class="hisui-checkbox" label="一般"><input type="checkbox" id="ZLXG3" data-formitem="ZLXG" class="hisui-checkbox" label="不满意"><input type="hidden" id="ZLXG" data-title="对本次手术的治疗效果" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">特殊情况登记</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right7"><span style="color:red">*</span>需要再次入院</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="ZCRY1" data-formitem="ZCRY" class="hisui-checkbox" label="是"><input type="checkbox" id="ZCRY2" data-formitem="ZCRY" class="hisui-checkbox" label="否"><input type="hidden" id="ZCRY" data-title="需要再次入院" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right7"><span style="color:red">*</span>需要急诊手术</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="JZSS1" data-formitem="JZSS" class="hisui-checkbox" label="是"><input type="checkbox" id="JZSS2" data-formitem="JZSS" class="hisui-checkbox" label="否"><input type="hidden" id="JZSS" data-title="需要急诊手术" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">其他</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>随访方式</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="SFFS1" data-formitem="SFFS" class="hisui-checkbox" label="电话"><input type="checkbox" id="SFFS2" data-formitem="SFFS" class="hisui-checkbox" label="微信"><input type="hidden" id="SFFS" data-title="需要再次入院" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>备注</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="text" id="Note" name="Note" class="textbox operdata" data-title="备注" data-permission="All" style="width:300px;" data-required="Y"/></div></div></td></tr>  </tbody> </table>'
var moudl1='<table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">术后身体情况</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>切口出血</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="QKCX1" data-formitem="QKCX" class="hisui-checkbox" label="是"><input type="checkbox" id="QKCX2" data-formitem="QKCX" class="hisui-checkbox" label="否"><input type="hidden" id="QKCX" data-title="切口出血" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>切口疼痛</div><div class="form-item" style="width:320px;margin-left:-5px;"><input type="checkbox" id="QKTT1" data-formitem="QKTT" class="hisui-checkbox" label="无痛"><input type="checkbox" id="QKTT2" data-formitem="QKTT" class="hisui-checkbox" label="轻度痛"><input type="checkbox" id="QKTT3" data-formitem="QKTT" class="hisui-checkbox" label="中度痛"><input type="checkbox" id="QKTT4" data-formitem="QKTT" class="hisui-checkbox" label="重度痛"><input type="checkbox" id="QKTT5" data-formitem="QKTT" class="hisui-checkbox" label="剧痛"><input type="hidden" id="QKTT" data-title="切口疼痛" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>是否发热</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="SFFR1" data-formitem="SFFR" class="hisui-checkbox" label="是"><input type="checkbox" id="SFFR1" data-formitem="SFFR" class="hisui-checkbox" label="否"><input type="hidden" id="SFFR" data-title="是否发热" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>排气/排便</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="PQPB1" data-formitem="PQPB" class="hisui-checkbox" label="异常"><input type="checkbox" id="PQPB2" data-formitem="PQPB" class="hisui-checkbox" label="正常"><input type="hidden" id="PQPB" data-title="排气/排便" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>头痛/晕眩</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="TTYX1" data-formitem="TTYX" class="hisui-checkbox" label="是"><input type="checkbox" id="TTYX2" data-formitem="TTYX" class="hisui-checkbox" label="否"><input type="hidden" id="TTYX" data-title="头痛/晕眩" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>四肢麻木</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="SZMM1" data-formitem="SZMM" class="hisui-checkbox" label="麻木"><input type="checkbox" id="SZMM2" data-formitem="SZMM" class="hisui-checkbox" label="正常"><input type="hidden" id="SZMM" data-title="四肢麻木" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>恶心/呕吐</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="EXOT1" data-formitem="EXOT" class="hisui-checkbox" label="是"><input type="checkbox" id="EXOT2" data-formitem="EXOT" class="hisui-checkbox" label="否"><input type="hidden" id="EXOT" data-title="恶心/呕吐" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>无食欲</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="WSY1" data-formitem="WSY" class="hisui-checkbox" label="是"><input type="checkbox" id="WSY2" data-formitem="WSY" class="hisui-checkbox" label="否"><input type="hidden" id="WSY" data-title="恶心/呕吐" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">生活情况及离院后依从性</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>能正常工作和日常家务</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="GZJW1" data-formitem="GZJW" class="hisui-checkbox" label="是"><input type="checkbox" id="GZJW2" data-formitem="GZJW" class="hisui-checkbox" label="否"><input type="hidden" id="GZJW" data-title="能正常工作和日常家务" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>感觉舒适，能控制情绪</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="GJQX1" data-formitem="GJQX" class="hisui-checkbox" label="是"><input type="checkbox" id="GJQX2" data-formitem="GJQX" class="hisui-checkbox" label="否"><input type="hidden" id="GJQX" data-title="感觉舒适，能控制情绪" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>遵从医嘱服药/活动指导</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="FYHD1" data-formitem="FYHD" class="hisui-checkbox" label="是"><input type="checkbox" id="FYHD2" data-formitem="FYHD" class="hisui-checkbox" label="否"><input type="hidden" id="FYHD" data-title="遵从医嘱服药/活动指导" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>出院后开车饮酒等</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="KCYJ1" data-formitem="KCYJ" class="hisui-checkbox" label="是"><input type="checkbox" id="KCYJ2" data-formitem="KCYJ" class="hisui-checkbox" label="否"><input type="hidden" id="KCYJ" data-title="出院后开车饮酒等" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">服务满意度</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>对日间手术的就医流程</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="JYLC1" data-formitem="JYLC" class="hisui-checkbox" label="满意"><input type="checkbox" id="JYLC2" data-formitem="JYLC" class="hisui-checkbox" label="一般"><input type="checkbox" id="JYLC3" data-formitem="JYLC" class="hisui-checkbox" label="不满意"><input type="hidden" id="JYLC" data-title="对日间手术的就医流程" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>对医护人员的服务态度</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="FWTD1" data-formitem="FWTD" class="hisui-checkbox" label="满意"><input type="checkbox" id="FWTD2" data-formitem="FWTD" class="hisui-checkbox" label="一般"><input type="checkbox" id="FWTD3" data-formitem="FWTD" class="hisui-checkbox" label="不满意"><input type="hidden" id="FWTD" data-title="对医护人员的服务态度" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right11"><span style="color:red">*</span>对本次手术的治疗效果</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="ZLXG1" data-formitem="ZLXG" class="hisui-checkbox" label="满意"><input type="checkbox" id="ZLXG2" data-formitem="ZLXG" class="hisui-checkbox" label="一般"><input type="checkbox" id="ZLXG3" data-formitem="ZLXG" class="hisui-checkbox" label="不满意"><input type="hidden" id="ZLXG" data-title="对本次手术的治疗效果" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">特殊情况登记</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right7"><span style="color:red">*</span>需要再次入院</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="ZCRY1" data-formitem="ZCRY" class="hisui-checkbox" label="是"><input type="checkbox" id="ZCRY2" data-formitem="ZCRY" class="hisui-checkbox" label="否"><input type="hidden" id="ZCRY" data-title="需要再次入院" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right7"><span style="color:red">*</span>需要急诊手术</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="JZSS1" data-formitem="JZSS" class="hisui-checkbox" label="是"><input type="checkbox" id="JZSS2" data-formitem="JZSS" class="hisui-checkbox" label="否"><input type="hidden" id="JZSS" data-title="需要急诊手术" class="operdata" data-multiple="N" data-required="Y"></div></div></td></tr>  </tbody> </table> <table style="width:100%;"><thead><tr> <th style="background-color:#f5f6f5">其他</th></tr></thead><tbody> <tr> <td> <div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>随访方式</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="checkbox" id="SFFS1" data-formitem="SFFS" class="hisui-checkbox" label="电话"><input type="checkbox" id="SFFS2" data-formitem="SFFS" class="hisui-checkbox" label="微信"><input type="hidden" id="SFFS" data-title="需要再次入院" class="operdata" data-multiple="N" data-required="Y"></div></div><div class="form-row"> <div class="form-title-right5"><span style="color:red">*</span>备注</div><div class="form-item" style="width:300px;margin-left:-5px;"><input type="text" id="Note" name="Note" class="textbox operdata" data-title="备注" data-permission="All" style="width:300px;" data-required="Y"/></div></div></td></tr>  </tbody> </table>'
//alert($("#Mould").html())
//$("#Mould").append(moudl);
//alert($("#Mould").html())

//$("#Mould1").append(moudl1)

//alert(1)
function initPage(){
    //alert(2)
    $(".spinner-text").each(function(index,item){
        var spinnerWidth=$(item).width();
        $(item).css("width",(spinnerWidth-5)+"px");
    });
    //设置默认值
    dhccl.parseDateFormat();
    initForm();
    initFollowupBox();
    setCheckChange();   //加载元素属性
    //initFollowupDetails();
    
}

function initForm(){
    setDefaultPatInfo();   //标题栏

    //新增随访记录
    $("#btnAdd").linkbutton({
        onClick: function() {
            addFollowupList();
        }
    });

    //删除随访记录
    $("#btnDelete").linkbutton({
        onClick: function() {
            deleteFollowupList();
        }
    });

    //保存随访明细
    $("#btnSave").linkbutton({
        onClick: function() {
            saveFollowupDetails(".operdata");
        }
    });

    //随访完成
    $("#btnFinish").linkbutton({
        onClick: function() {
            if(selectRow){
                var ret=isDataIntegrityNew(".operdata");
                //alert(ret)
                if(ret!="")
                {
                    $.messager.alert("提示",ret,"error")
                    return;
                }
                var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"FinishFollowupDetails",selectRow.RowId);
                //alert(123)
                if (ret=="0")
                {
                    //$.messager.alert("提示","成功！");
                    saveFollowupDetails(".operdata");
                    $("#followupList").datagrid("reload"); 
                }
            }
            else
            {
                $.messager.alert("提示","请选择一行！","error");
                return;
            }
        }
    });

    //新增随访内容框(确认)
    $("#btnConfirm").linkbutton({
        onClick: function() {
            confirmFollowupList();
        }
    });

    //新增随访内容框(取消)
    $("#btnCancel").linkbutton({
        onClick: function() {
            $("#addNoDate").dialog("close");
        }
    });

    //alert(123)
    $("#Moulds").combobox({
        valueField:"RowId",
        textField:"Description",
        editable:false,
        url:ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperFollowup;
            param.QueryName="FindFollowupMould";
            param.ArgCnt=0;
        },
        mode:"remote",
        onSelect:function(record){
            if(record.Code=="Default")
            {
                //alert($("#Mould").html())
                $("#Mould").empty();
                $("#Mould").append(moudl1);
                //alert($("#Mould").html())
                //setCheckChange();
                //operDataManager.setCheckChange();
                //alert($("#Mould").html())
            }
        },
        onLoadSuccess:function(data)
        {
            
        }
    });     
}


function setCheckChange() {
    $("input[type='checkbox']").each(function(index, item) {
        var dataFormItem = $(this).attr("data-formitem");
        if ($(this).hasClass("hisui-checkbox") && dataFormItem && dataFormItem !== "") {
            $(this).checkbox("options").onCheckChange = checkboxCheckChange;
        }
    });
}

function checkboxCheckChange(e, value) {
    var curCheckItem = $(this);
    var formItem = $(this).attr("data-formitem");
    if (!formItem || formItem === "") return;
    var checkSelector = "#" + $(this).attr("id");
    var dataSelector = "#" + formItem;
    //return;
    if (value === false) {
        operDataManager.setFormDataValue(formItem, $(this).attr("id"), value);
        if (operDataManager.checkChangeCallBack) {
            operDataManager.checkChangeCallBack();
        }
        return;
    }
   
    var multiChoice = $(dataSelector).attr("data-multiple") === "N" ? false : true;
    if (multiChoice === true) return;
    var groupSelector = "input[data-formitem='" + formItem + "']";
    var checkLabel = $(this).attr("label");
    if (!checkLabel || checkLabel === "") {
        checkLabel = $(this).attr("value");
    }
    $(groupSelector).each(function(index, item) {
        var curLabel = $(this).attr("label");
        if (!curLabel || curLabel === "") {
            curLabel = $(this).attr("value");
        }
        if (curLabel !== checkLabel) {
            $(this).checkbox("setValue", false);
        }
    });
    operDataManager.setFormDataValue(formItem, $(this).attr("id"), value);
    if (operDataManager.checkChangeCallBack) {
        operDataManager.checkChangeCallBack();
    }
}

//加载随访明细
function initFollowupDetails()
{
    clearData(".operdata")
    if(selectRow)
    {
        var operDatas = getOperDatas();
        operDataManager.setFormOperDatas(operDatas);
    }
    
}


//新增随访记录
function addFollowupList()
{
    $("#addNoDate").dialog("open")
    {
        $("#No").val("");
        var today=(new Date()).format("yyyy-MM-dd HH:mm");
        //alert()
        $("#Date").datetimebox("setValue",today);
    };
}

//新增随访框(确认)
function confirmFollowupList()
{
    var no=$("#No").val();
    var selectdate=$("#Date").datetimebox("getValue");
    var date=selectdate.split(" ")[0];
    var time=selectdate.split(" ")[1];
    //alert(no+"^"+date+"^"+time)
    var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"AddFollowupList",session.OPSID,session.UserID,no,date,time);
    if (ret=="0")
    {
        $.messager.alert("提示","添加成功！");
        $("#addNoDate").dialog("close");
        $("#followupList").datagrid("reload"); 
    }
    else
    {
        $.messager.alert("提示","添加失败，原因："+ret.result,"error")
    }
}

//删除随访记录
function deleteFollowupList()
{
    //alert(session.OPSID+"^"+session.UserID)
    //alert(selectRow.RowId+"^"+selectRow.Status)
    if(selectRow){
        $.messager.confirm("提示","是否删除此病人第"+selectRow.No+"次的随访记录",function (r)
        {
            if(r)
            {
                var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"DeleteFollowupList",selectRow.RowId);
                if (ret=="0")
                {
                    $.messager.alert("提示","删除成功！");
                    $("#followupList").datagrid("reload"); 
                }
                else
                {
                    $.messager.alert("提示","删除失败，原因："+ret,"error")
                }
            } 
        } );
    }
    else
    {
        $.messager.alert("提示","请选择一行！","error");
        return;
    }
   
}

//保存随访明细
function saveFollowupDetails(selector)
{
    if(selectRow){
        var operDataSelector = (selector && selector != "") ? selector : ".operdata";
        var operDatas = getFormOperDatas(operDataSelector);
        if (!operDatas || !operDatas.length || operDatas.length <= 0) return;
        var jsonData = dhccl.formatObjects(operDatas);
        //alert(selectRow)
    
        var ret=dhccl.runServerMethod(ANCLS.BLL.OperFollowup,"SaveFollowupDetails",selectRow.RowId,jsonData);
        //alert(ret)
        if(ret=="0")
        {
            $.messager.alert("提示","保存成功！")
            initFollowupDetails();
        }
        else
        {
            $.messager.alert("提示","保存失败，原因："+ret,"error")
        }
    }
    else
    {
        $.messager.alert("提示","请选择一行随访记录！","error");
        return;
    }
}

//判断必填内容
function isDataIntegrityNew(clsSelector){
    var ret=true,messages=[];

    $(clsSelector).each(function(index,el){
        var selector = "#" + $(el).attr("id");
        var enabled=operDataManager.getOperDataAbleStatus(selector);
        //alert(selector+"^"+enabled)
        if(enabled===false) return;
        var required=$(selector).attr("data-required");
        if(required!=="Y"){
            return;
        }
        
        var dataRowId=$(selector).attr("data-rowid");
        var dataValue=$(selector).attr("data-value");
        var dataScore=$(selector).attr("data-score");
        var dataMsg=$(selector).attr("data-title");
        if((dataRowId && dataRowId!=="") && ((dataValue && dataValue!=="") || (dataScore && dataScore!==""))) return;

        var hasDirtyValue=operDataManager.existsDirtyValue(selector);
        //alert(selector+"^"+hasDirtyValue)
        if(hasDirtyValue) return;
        ret=false;
        messages.push("未选择"+" "+dataMsg);
    });
    var message="";
    if(messages.length>0){
        message=messages.join(",");
    }
    return message;
}

//获取随访明细
function getOperDatas() {
    var operDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperFollowup,
        QueryName: "FindFollowupDetails",
        Arg1: selectRow.RowId,
        ArgCnt: 1
    }, "json");
    return operDatas;
}

//获取随访明细内容(保存用)
function getFormOperDatas(clsSelector) {
    var valueArr = [];
    var dataValue = null;
    var operDatas = [];
    $(clsSelector).each(function(index, el) {
        valueArr.length = 0;
        dataValue = null;
        var selector = "#" + $(el).attr("id");
        //alert(selector)
        var enabled = operDataManager.getControlAbleStatus($(selector));
        if (enabled === false) return;
        var checkSelector = "input[data-formitem='" + $(el).attr("id") + "']";
        if ($(checkSelector).length > 0) {
            var controlEnabled;
            $(checkSelector).each(function(checkInd, checkItem) {
                enabled = operDataManager.getControlAbleStatus($(checkItem));
                if (enabled === false)
                {
                    controlEnabled=false;
                    return;
                }
                var checkValue = false;
                if ($(checkItem).hasClass("hisui-checkbox")) {
                    checkValue = $(checkItem).checkbox("getValue");
                } else if ($(checkItem).hasClass("hisui-radio")) {
                    checkValue = $(checkItem).radio("getValue");
                }
                if (!checkValue) return;
                if (valueArr.length > 0) valueArr.push(splitchar.comma);
                var curLabel = $(checkItem).attr("label");
                if (!curLabel || curLabel === "") {
                    curLabel = $(checkItem).attr("value");
                }
                
                valueArr.push(curLabel);
            });
            if(controlEnabled===false) return;
            dataValue = valueArr.join(splitchar.empty);
        } else {
            dataValue = operDataManager.getControlValue($(el));
        }
        var dataControl=$(selector).attr("data-control");
        if(dataControl && dataControl==="N"){
            dataValue=$(selector).attr("data-value");
        }
        var dataScore = $(el).attr("data-score");
        var operDataId = $(el).attr("data-rowid");
        // 如果不是已保存过的数据，且数据值或分数值为空，那么不保存
        if ((!operDataId || operDataId === "") && (!dataValue || dataValue === "") && (!dataScore || dataScore === "")) return;
        operDatas.push({
            RowId: $(el).attr("data-rowid"),
            RecordSheet: session.RecordSheetID,
            DataItem: $(el).attr("id"),
            DataValue: dataValue,
            UpdateUserID: session.UserID,
            ClassName: "CIS.AN.OperFollowupDetails",
            DataScore: dataScore ? dataScore : ""
        });
    });

    return operDatas;
}

//清除随访明细(切换记录用)
function clearData(clsSelector) {
    $(clsSelector).each(function(index, el) {
        var selector = "#" + $(el).attr("id");
        //alert(selector)
        var enabled = operDataManager.getControlAbleStatus($(selector));
        if (enabled === false) return;
        var checkSelector = "input[data-formitem='" + $(el).attr("id") + "']";
        if ($(checkSelector).length > 0) {
            var controlEnabled;
            $(checkSelector).each(function(checkInd, checkItem) {
                enabled = operDataManager.getControlAbleStatus($(checkItem));
                if (enabled === false)
                {
                    controlEnabled=false;
                    return;
                }
                var checkValue = false;
                if ($(checkItem).hasClass("hisui-checkbox")) {
                    $(checkItem).checkbox('setValue',false);
                } else if ($(checkItem).hasClass("hisui-radio")) {
                    checkValue = $(checkItem).radio('setValue',false);
                }
                if (!checkValue) return;
                var curLabel = $(checkItem).attr("label");
                if (!curLabel || curLabel === "") {
                    curLabel = $(checkItem).attr("value");
                }
            });
            if(controlEnabled===false) return;
        } else {
            clearControlValue($(el));
        }
        $(el).removeAttr("data-rowid")
        
       
    });
}

//清除界面元素内容
function clearControlValue(jqueryObj) {
    if (jqueryObj.hasClass(Controls.ComboBox)) {
         ret = jqueryObj.combobox("clear");
    } else if (jqueryObj.hasClass(Controls.CheckBox)) {
        jqueryObj.checkbox('setValue',false);

    } else if (jqueryObj.hasClass(Controls.Radio)) {
        jqueryObj.radio('setValue',false);
    } else if (jqueryObj.hasClass(Controls.DateBox)) {
        jqueryObj.datebox("clear");
    } else if (jqueryObj.hasClass(Controls.DateTimeBox)) {
        jqueryObj.datetimebox("clear");
    } else if (jqueryObj.hasClass(Controls.ValidateBox)) {
        jqueryObj.val("");
    } else if (jqueryObj.hasClass(Controls.NumberBox)) {
        jqueryObj.numberbox('setValue',"")
    } else if (jqueryObj.hasClass(Controls.TimeSpinner)) {
        queryObj.timespinner('setValue',"")
    } else {
        jqueryObj.val("");
    }
}


//标题栏
function setDefaultPatInfo()
{
    var banner=operScheduleBanner.init('#patinfo_banner', {});
     dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindPatient",
        Arg1: EpisodeID,
        ArgCnt: 1
     }, "json", true, function(appDatas) {
        if (appDatas && appDatas.length > 0) {
               banner.loadData(appDatas[0]);
            
         }
    });
    
}

//获取标题栏内容
function getEpisodeByMenu(){
    var EpisodeID="";
	var dhc={
		/*
		获取url传递的参数值
		*/
		getUrlParam:function(name)
		{
			var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
			var r = window.location.search.substr(1).match(reg);
			if (r != null) return unescape(r[2]);
			return null;
		}	
	}
    EpisodeID=dhc.getUrlParam("EpisodeID");
    return EpisodeID;
}

//加载随访列表
function initFollowupBox(){

    // 设置表格属性
    var columns=[[
        {field:"DateTime",title:"随访日期",width:180},
        {field:"No",title:"随访次数",width:80},
        {field:"Type",title:"随访类型",width:90},
        {field:"User",title:"操作人员",width:120},
        {field:"Status",title:"状态",width:90},
        {field:"RowId",title:"RowId",width:90,hidden:true},
    ]];
	//alert(session.OPSID)
    $("#followupList").datagrid({
        fit:true,
        // nowrap:false,
        title:"术后随访记录",
        headerCls:"panel-header-gray",
        columns:columns,
        toolbar:"#followupTools",
        iconCls:"icon-paper",
        rownumber:true,
        pagination: true,
        pageSize: 50,
        pageList: [50, 100],
        checkOnSelect:false,
        selectOnCheck:false,
        singleSelect:true,
        url: ANCSP.DataQuery,
        onBeforeLoad:function(param){
            param.ClassName=ANCLS.BLL.OperFollowup;
            param.QueryName="FindFollowupList";
            param.Arg1=session.OPSID;
            param.ArgCnt=1;
        },
        onSelect:function(rowIndex,rowData){
            selectRow=rowData;
            initFollowupDetails();
        },
        onLoadSuccess:function(data)
        {
            $('#followupList').datagrid("selectRow", 0);
            //alert(selectRow.RowId)
            initFollowupDetails();
        }
    });

}

$(document).ready(initPage);

