<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\CuisineTypeResource;
use App\Models\CuisineType;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class CuisineTypeController extends Controller
{
    public function index(): AnonymousResourceCollection
    {
        return CuisineTypeResource::collection(CuisineType::all());
    }
}
