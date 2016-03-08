using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;

namespace PasteMarxicoHeader
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var ae = new AutoResetEvent(false);

            var newThread = new Thread(new ThreadStart(() => 
            {
                var date = DateTime.Now.ToString($@"yyMMdd");
                var headerStr = File.ReadAllText("header-template.txt");
                headerStr = headerStr.Replace("{date}", date);
                Clipboard.SetData(DataFormats.Text, headerStr);
                ae.Set();
            }));

            newThread.SetApartmentState(ApartmentState.STA);
            newThread.Start();
            ae.WaitOne();
        }
    }
}
