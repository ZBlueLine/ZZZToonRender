 float Wvalue(float x,float e0,float e1) 
    {

        float a = saturate((x - e0) / (e1 - e0));
        return a * a*(3 - 2 * a);
    }
    float Hvalue(float x, float e0, float e1)
    {
    
        return saturate((x - e0) / (e1 - e0));
    }

    float NewTonamap(float x, float a, float b, float c, float d, float e, float f)
    {
        float l0 = (a - c)*d / b;
        float L_x = c + b * (x - c);
        float T_x = c * pow(x / c, e) + f;
        float S0 = c + l0;
        float S1 = c + b * l0;
        float C2 = b * b / (b - S1);
        float S_x = b - (b - S1)*pow(e,-(C2*(x-S0)/b));
        float w0_x = 1 - Wvalue(x, 0, c);
        float w2_x = Hvalue(x, c + l0, c + l0);
        float w1_x = 1 - w0_x - w2_x;
        float f_x = T_x * w0_x + L_x * w1_x + S_x * w2_x;
        return f_x;
    }

    float3 GanshinTonemap(float3 x, float FilmSlopes, float FilmToest, float FilmShoulderg, float FilmShouldergt, float FilmBlackClipe, float FilmBlackClipet)
    {
        // GanshinTonemap
        // float a = 1;
        // float b = 1;
        // float c = 0.32;
        // float d = 0.32;
        // float e = 1.33;
        // float f = 0;

        float a = FilmSlopes;
        float b = FilmToest;
        float c = FilmShoulderg;
        float d = FilmShouldergt;
        float e = FilmBlackClipe;
        float f = FilmBlackClipet;
        
        x.r = NewTonamap(x.r, a, b, c, d, e, f);
        x.g = NewTonamap(x.g, a, b, c, d, e, f);
        x.b = NewTonamap(x.b, a, b, c, d, e, f);

        return x;
    }