using System.Globalization;

namespace Application.Exceptions
{
    public class ApiException : Exception
    {
        //V 10
        public ApiException():base()
        {

        }

        public ApiException(string message) : base(message)
        {

        }

        public ApiException(string message, params object[] args) : base(String.Format(CultureInfo.CurrentCulture,message , args))
        {

        }
    }
}
