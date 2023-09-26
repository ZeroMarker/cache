Class User.ZhaoZiHaoLC Extends %RegisteredObject
{

/// Description:	返回n小时后的时间日期
/// Creator:		赵子豪
/// CreateDate:	2023年9月16日
/// Debug:		w ##class(User.ZhaoZiHaoLC).GetDateTime(3) // 3小时后
/// Debug: 		w ##class(User.ZhaoZiHaoLC).GetDateTime(3) // 24小时后
/// Debug: 		w ##class(User.ZhaoZiHaoLC).GetDateTime(3) // 72小时后
ClassMethod GetDateTime(n As %Integer) As %String
{
        Set ONEDAY = 86400  // 一天的秒数

        Quit:n<0 "不允许负值"

        Set currentDay = $PIECE($HOROLOG, ",", 1)  // 当前日
        Set currentHour = $PIECE($HOROLOG, ",", 2) // 当前秒

        Set newHour = currentHour + (n*3600)  // 新的秒数
        Set newDay = currentDay + (newHour\ONEDAY)  // 新的日期

        // 如果新的秒数超过了一天，对 ONEDAY 取模
        If (newHour > 86400) { Set newHour = newHour # ONEDAY }
        
        // 拼接新的时间并转换格式
        // Set newDate = $ZDATETIME(newDay_","_newHour, 3)
        Set newDay = $ZDATE(newDay, 3)
        Set newHour = $ZTIME(newHour)

        Quit newDay_" "_newHour
}

/// Description:	统计出该病人就诊总次数（包含所有就诊类型）, 并返回总数
/// Creator:		赵子豪
/// CreateDate:	2023年9月16日
/// Debug:		w ##class(User.ZhaoZiHaoLC).CountPAPMI("张三一")
ClassMethod CountPAPMI(PAPMIName As %String) As %String
{
        Quit:PAPMIName="" "姓名不允许为空"
        Set papamiRowid = ""
        Set name = $ZCONVERT(PAPMIName, "U")
        Set papamiRowid = $ORDER(^PAPERi("PAPER_PatName", name, papamiRowid))
        Quit:papamiRowid="" "不存在该姓名的病人"
        // 遍历所有就诊类型
        Set paAdmType = ""
        Set count = 0
        For {
                // 遍历当前就诊类型的就诊记录
                Set paAdmType = $ORDER(^PAPERdr(papamiRowid, "ADM", paAdmType))
                Quit:paAdmType=""  // 循环出口
                Set paAdmRowid = ""
                For {
                        Set paAdmRowid = $ORDER(^PAPERdr(papamiRowid, "ADM", paAdmType, paAdmRowid))
                        Quit:paAdmRowid=""
                        Set count = count + 1
                }
        }
        Quit count
}

/// Description:	按床号输出姓名
/// Creator:		赵子豪
/// CreateDate:	2023年9月16日
/// Debug:		d ##class(User.ZhaoZiHaoLC).PrintByBadNo()
ClassMethod PrintByBadNo()
{
        Kill ^TempB
        Set ^TempB(1) = "学生姓名01^1050^小单人床F"
        Set ^TempB(2) = "学生姓名02^1000^大单人床A"
        Set ^TempB(3) = "学生姓名03^1020^单人床C"
        Set ^TempB(4) = "学生姓名04^1030^贵单人床D"
        Set ^TempB(5) = "学生姓名05^1010^便宜单人床B"

        // 创建索引
        Set rowId = 0
        For {
                Set rowId = $ORDER(^TempB(rowId))
                Quit:rowId=""  // 循环出口
                Set badNo = $PIECE($GET(^TempB(rowId)), "^", 2)  // 以^为分隔符取第2个位置的字符串
                Set ^TempB(0, "BadNo", badNo, rowId)=""
        }
        // 使用索引匹配Id, 并输出相应学生姓名
        Set code = ""
        For {
                Set code = $ORDER(^TempB(0, "BadNo", code))
                Quit:code=""  // 循环出口
                Set id = $ORDER(^TempB(0, "BadNo", code, 0))
                Write $PIECE(^TempB(id), "^", 1), !  // 以^为分隔符取第1个位置的字符串
        }
}

}
