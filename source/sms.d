module smsapi_d_client.sms;

class SmsapiClient
{
	string host, username, passwordHash;

	static SmsapiClient createSmsapiPl(string username, string passwordHash)
	{
		return new SmsapiClient("https://api.smsapi.pl", username, passwordHash);
	}

	static SmsapiClient createSmsapiPlAlternative(string username, string passwordHash)
	{
		return new SmsapiClient("https://api2.smsapi.pl", username, passwordHash);
	}

	static SmsapiClient createSmsapiCom(string username, string passwordHash)
	{
		return new SmsapiClient("https://api.smsapi.com", username, passwordHash);
	}

	static SmsapiClient createSmsapiComAlternative(string username, string passwordHash)
	{
		return new SmsapiClient("https://api2.smsapi.com", username, passwordHash);
	}

	this(string host, string username, string passwordHash)
	{
        this.host = host;
        this.username = username;
        this.passwordHash = passwordHash;
	}

	SmsSender createSmsSender()
	{
		return new SmsSender(host, username, passwordHash);
	}
}

class SmsSender
{
    import std.datetime: SysTime;
    import std.array: join;

	private {
		immutable string host;
	    string[string] query;
	}

	this(string host, string username, string passwordHash)
	{
		this.host = host;

		query["username"] = username;
		query["password"] = passwordHash;
	}

	SmsSender flash()
	{
	    query["flash"] = "1";

		return this;
	}

	SmsSender test()
	{
	    query["test"] = "1";

		return this;
	}

	SmsSender details()
	{
	    query["details"] = "1";

		return this;
	}

	SmsSender idx(string idx)
	{
        query["idx"] = idx;

		return this;
	}

	SmsSender checkIdx()
	{
        query["check_idx"] = "1";

		return this;
	}

	SmsSender date(SysTime date)
	{
        query["date"] = date.toISOExtString;

		return this;
	}

	SmsSender dateValidate()
	{
        query["date_validate"] = "1";

		return this;
	}

	SmsSender expirationDate(SysTime expirationDate)
	{
        query["expiration_date"] = expirationDate.toISOExtString;

		return this;
	}

	SmsSender from(string from)
	{
        query["from"] = from;

		return this;
	}

	SmsSender udh(string udh)
	{
        query["udh"] = udh;
        query["datacoding"] = "bin";

		return this;
	}

	SmsSender discountGroup(string discountGroup)
	{
        query["discount_group"] = discountGroup;

		return this;
	}

	SmsSender partnerId(string partnerId)
	{
        query["partner_id"] = partnerId;

		return this;
	}

	SmsSender parameters(string[] param1, string[] param2, string[] param3, string[] param4)
	{
        query["param1"] = param1.join("|");
        query["param2"] = param2.join("|");
        query["param3"] = param3.join("|");
        query["param4"] = param4.join("|");

		return this;
	}

	SmsSender message(string message)
	{
        query["message"] = message;

		return this;
	}

	SmsSender noUnicode()
	{
        query["nounicode"] = "1";

		return this;
	}

	SmsSender normalize()
	{
        query["normalize"] = "1";

		return this;
	}

	SmsSender skipForeign()
	{
        query["skip_foreign"] = "1";

		return this;
	}

	SmsSender allowDuplicates()
	{
        query["allow_duplicates"] = "1";

		return this;
	}

	SmsSender to(string[] to)
	{
        query["to"] = to.join(",");

		return this;
	}

	SmsSender notifyUrl(string notifyUrl)
	{
        query["notify_url"] = notifyUrl;

		return this;
	}

	SmsSender group(string group)
	{
        query["group"] = group;

		return this;
	}

	SmsSender maxParts(ubyte maxParts)
	{
	    import std.conv: text;

        query["max_parts"] = maxParts.text;

		return this;
	}

	SmsSender encoding(string encoding)
	{
        query["encoding"] = encoding;

		return this;
	}

	char[] send()
	{
        import std.net.curl: get;

		string queryString = "json=1";
		foreach (string name, string value; query) {
			queryString ~= "&" ~ name ~ "=" ~ value;
		}

		return get(host ~ "/sms.do?" ~ queryString);
	}
}

unittest
{
    import std.stdio: writeln;

    SmsapiClient client = SmsapiClient.createSmsapiPl("email", "password");
    SmsSender sender = client.createSmsSender;

    char[] output = sender
        .test()
        .to(["790216004"])
        .message("test")
        .send();

    writeln(output);
}