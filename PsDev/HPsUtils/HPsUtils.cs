using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HPsUtils
{
    public static class HPsUtils
    {
        public static int Add(int a, int b)
        {
            Console.WriteLine("a+b");
            return a + b;
        }

        public static List<string> GetStrings()
        {
            return new List<string>()
            {
                "a",
                "b",
            };
        }

        public static void Zip(string dir, string zipFile)
        {
            try
            {
                ZipFile.CreateFromDirectory(dir, zipFile);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

        public static void Unzip(string dir, string zipFile)
        {
            try
            {
                ZipFile.ExtractToDirectory(zipFile, dir);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }
    }
}
