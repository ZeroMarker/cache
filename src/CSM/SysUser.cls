Class CSM.SysUser Extends (%Persistent, %Populate) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// 申请码
Property ApplyCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 生日
Property BirthDay As %String(MAXLEN = 30, TRUNCATE = 1);

/// 中文姓名
Property CName As %String(MAXLEN = 20, TRUNCATE = 1) [ Required ];

/// 能否修改登录信息（用户名和密码）（1-可以，0-不可以）
Property CanChangeLoginInfo As %String(MAXLEN = 1, TRUNCATE = 1) [ Required ];

/// 审核日期
Property ConfirmDate As %String(MAXLEN = 30, TRUNCATE = 1);

/// 在医疗机构中的所属部门ID
Property DeptID As %Integer;

/// 描述
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 英文姓名
Property EName As %String(TRUNCATE = 1);

/// 电子邮件
Property Email As %String(MAXLEN = 100, TRUNCATE = 1);

/// 失效日期
Property EndDate As %String(MAXLEN = 30, TRUNCATE = 1);

/// 第一次登录日期时间
Property FirstDateTime As %String(MAXLEN = 30, TRUNCATE = 1);

/// 第一次访问IP
Property FirstIP As %String(MAXLEN = 15, TRUNCATE = 1);

/// 性别：男1女2不确定0未知-1
Property Gender As %Integer;

/// 用户编号
/// Property UserID As %String(MAXLEN = 20) [ Required ];
/// 家中电话
Property HomeTel As %String(MAXLEN = 30, TRUNCATE = 1);

/// 身份证号码
Property IDCard As %String(MAXLEN = 30, TRUNCATE = 1);

/// 最后访问时间
Property LastDateTime As %String(MAXLEN = 30, TRUNCATE = 1);

/// 最后访问IP
Property LastIP As %String(MAXLEN = 15, TRUNCATE = 1);

/// 登录名
Property LoginName As %String(MAXLEN = 20, TRUNCATE = 1);

/// 锁定机器Mac地址
Property MacAddr As %String(TRUNCATE = 1);

/// 手机号
Property MobileNo As %String(MAXLEN = 15, TRUNCATE = 1);

/// 工作电话
Property OfficeTel As %String(MAXLEN = 30, TRUNCATE = 1);

/// 登录密码，md5加密字符
Property Password As %String(MAXLEN = 32, TRUNCATE = 1);

/// 生效日期
Property StartDate As %String(MAXLEN = 30, TRUNCATE = 1);

/// 用户照片网址
Property PhotoUrl As %String(MAXLEN = 255, TRUNCATE = 1);

/// 当前状态：1:正常/0:禁止登陆/ -1:删除
Property Status As %Integer;

/// 用户类型：S-系统级用户，可以同时参与多个项目，P-项目级用户，只能参与一个项目
Property UserType As %String(MAXLEN = 1, TRUNCATE = 1) [ Required ];

Index CNameIndex On CName;

Index IdxLoginName On LoginName [ Unique ];

Storage Default
{
<Data name="SysUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CName</Value>
</Value>
<Value name="3">
<Value>EName</Value>
</Value>
<Value name="4">
<Value>Email</Value>
</Value>
<Value name="5">
<Value>UserNo</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
<Value name="8">
<Value>IDCard</Value>
</Value>
<Value name="9">
<Value>MacAddr</Value>
</Value>
<Value name="10">
<Value>StartDate</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>BirthDay</Value>
</Value>
<Value name="13">
<Value>Gender</Value>
</Value>
<Value name="14">
<Value>HomeTel</Value>
</Value>
<Value name="15">
<Value>LastDateTime</Value>
</Value>
<Value name="16">
<Value>LastIP</Value>
</Value>
<Value name="17">
<Value>MobileNo</Value>
</Value>
<Value name="18">
<Value>OfficeTel</Value>
</Value>
<Value name="19">
<Value>PhotoUrl</Value>
</Value>
<Value name="20">
<Value>UserID</Value>
</Value>
<Value name="21">
<Value>CanChangeLoginInfo</Value>
</Value>
<Value name="22">
<Value>LoginName</Value>
</Value>
<Value name="23">
<Value>UserType</Value>
</Value>
<Value name="24">
<Value>Password</Value>
</Value>
<Value name="25">
<Value>DeptID</Value>
</Value>
<Value name="26">
<Value>FirstDateTime</Value>
</Value>
<Value name="27">
<Value>FirstIP</Value>
</Value>
<Value name="28">
<Value>ApplyCode</Value>
</Value>
<Value name="29">
<Value>ConfirmDate</Value>
</Value>
</Data>
<DataLocation>^CSM.SysUserD</DataLocation>
<DefaultData>SysUserDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.SysUserD</IdLocation>
<IndexLocation>^CSM.SysUserI</IndexLocation>
<StreamLocation>^CSM.SysUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
